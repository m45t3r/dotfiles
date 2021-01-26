{ config, lib, pkgs, ... }:
let
  # Aliases
  alt = "Mod1";
  modifier = "Mod4";

  commonOptions = let
    rofi = "${config.programs.rofi.package}/bin/rofi";
    mons = "${pkgs.mons}/bin/mons";
    screenShotName = with config.xdg.userDirs;
      "${pictures}/$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)-screenshot.png";
    displayLayoutMode =
      " : [h]  , [j]  , [k]  , [l]  , [d]uplicate, [m]irror, [s]econd-only, [o]ff";
  in import ./i3-common.nix rec {
    inherit config lib modifier alt;

    browser = "firefox";
    fileManager = "${terminal} ${pkgs.nnn}/bin/nnn";
    statusCommand = with config;
      "${programs.i3status-rust.package}/bin/i3status-rs ${xdg.configHome}/i3status-rust/config-i3.toml";
    menu = "${rofi} -show drun";
    # light needs to be installed in system, so not defining a path here
    light = "light";
    pactl = "${pkgs.pulseaudio}/bin/pactl";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    terminal = config.my.terminal;

    # Screenshots
    fullScreenShot = ''
      ${pkgs.maim}/bin/maim -u "${screenShotName}" && \
      ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Full screenshot taken'
    '';
    areaScreenShot = ''
      ${pkgs.maim}/bin/maim -u -s "${screenShotName}" && \
      ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Area screenshot taken'
    '';

    extraBindings = {
      "${modifier}+p" = ''mode "${displayLayoutMode}"'';
      "${modifier}+c" =
        "exec ${rofi} -show calc -modi calc -no-show-match -no-sort";
      "${modifier}+Tab" = "exec ${rofi} -show window -modi window";
    };

    extraModes = with commonOptions.helpers; {
      ${displayLayoutMode} = (mapDirection {
        leftCmd = "mode default, exec ${mons} -e left";
        downCmd = "mode default, exec ${mons} -e bottom";
        upCmd = "mode default, exec ${mons} -e top";
        rightCmd = "mode default, exec ${mons} -e right";
      }) // {
        d = "mode default, exec ${mons} -d";
        m = "mode default, exec ${mons} -m";
        s = "mode default, exec ${mons} -s";
        o = "mode default, exec ${mons} -o";
        "Escape" = "mode default";
        "Return" = "mode default";
      };
    };
  };
in {
  imports = [ ./dunst.nix ./i3status-rust.nix ./rofi.nix ];

  nixpkgs.overlays = [
    (import (fetchGit {
      url = "https://github.com/thiagokokada/i3pyblocks";
      ref = "nix-overlay";
    }))
  ];

  xsession.enable = true;
  xsession.windowManager.i3 = with commonOptions; {
    enable = true;

    inherit extraConfig;

    config = commonOptions.config // {
      startup = [
        {
          command = "${pkgs.xorg.xset}/bin/xset s 600 30";
          notification = false;
        }
        {
          command = "${pkgs.dex}/bin/dex --autostart";
          notification = false;
        }
      ];

    };
  };

  xdg.userDirs.enable = true;

  services = { udiskie.enable = true; };

  systemd.user.services = {
    kbdd = {
      Unit = {
        Description = "kbdd daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.kbdd}/bin/kbdd -n";
        Type = "dbus";
        BusName = "ru.gentoo.KbddService";
      };
    };

    xss-lock = {
      Unit = {
        Description = "Use external locker as X screen saver";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = let
        lockscreen = with config.my.fonts;
          pkgs.writeShellScriptBin "lock-screen" ''
            export XSECURELOCK_FORCE_GRAB=2
            export XSECURELOCK_BLANK_DPMS_STATE="off"
            export XSECURELOCK_DATETIME_FORMAT="%H:%M:%S - %a %d/%m"
            export XSECURELOCK_SHOW_DATETIME=1
            export XSECURELOCK_SHOW_HOSTNAME=0
            export XSECURELOCK_SHOW_USERNAME=0
            export XSECURELOCK_FONT="${gui.name}:style=Regular"

            exec ${pkgs.xsecurelock}/bin/xsecurelock $@
          '';
        notify = pkgs.writeShellScriptBin "notify" ''
          ${pkgs.libnotify}/bin/notify-send -t 30 "30 seconds to lock"
        '';
      in {
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.xss-lock}/bin/xss-lock"
          "--notifier ${notify}/bin/notify"
          "--transfer-sleep-lock"
          "--session $XDG_SESSION_ID"
          "--"
          "${lockscreen}/bin/lock-screen"
        ];
      };
    };
  };

  home.packages = with pkgs; [
    dex
    kbdd
    libnotify
    maim
    mons
    nnn
    playerctl
    xorg.xkill
    xorg.xset
    xsecurelock
    xss-lock
  ];
}
