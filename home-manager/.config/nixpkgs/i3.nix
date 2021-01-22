{ config, lib, pkgs, ... }:

let
  # Aliases
  alt = "Mod1";
  modifier = "Mod4";
  workspaces = [
    {
      ws = 1;
      name = "1:  ";
    }
    {
      ws = 2;
      name = "2:  ";
    }
    {
      ws = 3;
      name = "3:  ";
    }
    {
      ws = 4;
      name = "4:  ";
    }
    {
      ws = 5;
      name = "5:  ";
    }
    {
      ws = 6;
      name = "6:  ";
    }
    {
      ws = 7;
      name = "7:  ";
    }
    {
      ws = 8;
      name = "8:  ";
    }
    {
      ws = 9;
      name = "9:  ";
    }
    {
      ws = 0;
      name = "10:  ";
    }
  ];

  # Modes
  displayLayoutMode =
    " : [h]  , [j]  , [k]  , [l]  , [d]uplicate, [m]irror, [s]econd-only, [o]ff";
  powerManagementMode =
    " : Screen [l]ock, [e]xit i3, [s]uspend, [h]ibernate, [R]eboot, [S]hutdown";
  resizeMode = " : [h]  , [j]  , [k]  , [l] ";

  # Programs
  browser = "firefox";
  fileManager = "${terminal} ${pkgs.nnn}/bin/nnn";
  dex = "${pkgs.dex}/bin/dex";
  kbdd = "${pkgs.kbdd}/bin/kbdd";
  i3pyblocks = "${pkgs.i3pyblocks}/bin/i3pyblocks";
  i3pyblocksConfig = config.my.dotfiles-dir
    + "/i3/.config/i3pyblocks/config.py";
  # light needs to be installed in system, so not defining a path here
  light = "light";
  menu = "${config.programs.rofi.package}/bin/rofi";
  mons = "${pkgs.mons}/bin/mons";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  terminal = config.my.terminal;
  xset = "${pkgs.xorg.xset}/bin/xset";

  # Screenshots
  screenShotName =
    "$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)-screenshot.png";
  fullScreenShot = with config.xdg.userDirs; ''
    ${pkgs.maim}/bin/maim "${pictures}/${screenShotName}" && \
    ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Full screenshot taken'
  '';
  areaScreenShot = with config.xdg.userDirs; ''
    ${pkgs.maim}/bin/maim -s "${pictures}/${screenShotName}" && \
    ${pkgs.libnotify}/bin/notify-send -u normal -t 5000 'Area screenshot taken'
  '';

  # Helpers
  mapDirection = { prefixKey ? null, leftCmd, downCmd, upCmd, rightCmd }:
    with lib.strings; {
      # Arrow keys
      "${optionalString (prefixKey != null) "${prefixKey}+"}Left" = leftCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Down" = downCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Up" = upCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}Right" = rightCmd;
      # Vi-like keys
      "${optionalString (prefixKey != null) "${prefixKey}+"}h" = leftCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}j" = downCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}k" = upCmd;
      "${optionalString (prefixKey != null) "${prefixKey}+"}l" = rightCmd;
    };
  mapDirectionDefault = { prefixKey ? null, prefixCmd }:
    (mapDirection {
      inherit prefixKey;
      leftCmd = "${prefixCmd} left";
      downCmd = "${prefixCmd} down";
      upCmd = "${prefixCmd} up";
      rightCmd = "${prefixCmd} right";
    });
  mapWorkspacesStr = with builtins;
    with lib.strings;
    { workspaces, prefixKey ? null, prefixCmd }:
    (concatStringsSep "\n" (map ({ ws, name }:
      ''
        bindsym ${optionalString (prefixKey != null) "${prefixKey}+"}${
          toString ws
        } ${prefixCmd} "${name}"'') workspaces));

in {
  imports = [ ./dunst.nix ./rofi.nix ];

  my.terminal = "${pkgs.kitty}/bin/kitty";

  nixpkgs.overlays = [
    (import (fetchGit {
      url = "https://github.com/thiagokokada/i3pyblocks";
      ref = "nix-overlay";
    }))
  ];

  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;

    config = rec {
      inherit modifier menu terminal;
      fonts = with config.my.fonts; [
        gui.name
        "Font Awesome 5 Brands Regular 8"
        "Font Awesome 5 Free Solid 8"
      ];

      bars = with config.my.theme.colors; [{
        position = "top";
        statusCommand = "${i3pyblocks} -c ${i3pyblocksConfig}";
        colors = {
          background = base00;
          separator = base01;
          statusline = base04;
          activeWorkspace = {
            border = base03;
            background = base03;
            text = base00;
          };
          bindingMode = {
            border = base0A;
            background = base0A;
            text = base00;
          };
          focusedWorkspace = {
            border = base0D;
            background = base0D;
            text = base00;
          };
          inactiveWorkspace = {
            border = base01;
            background = base01;
            text = base05;
          };
          urgentWorkspace = {
            border = base08;
            background = base08;
            text = base00;
          };
        };
      }];

      colors = with config.my.theme.colors; {
        background = base07;
        focused = {
          background = base0D;
          border = base0D;
          childBorder = base0C;
          indicator = base0D;
          text = base00;
        };
        focusedInactive = {
          background = base01;
          border = base01;
          childBorder = base01;
          indicator = base03;
          text = base05;
        };
        placeholder = {
          background = base00;
          border = base00;
          childBorder = base00;
          indicator = base00;
          text = base05;
        };
        unfocused = {
          background = base00;
          border = base01;
          childBorder = base01;
          indicator = base01;
          text = base05;
        };
        urgent = {
          background = base08;
          border = base08;
          childBorder = base08;
          indicator = base08;
          text = base00;
        };
      };

      keybindings = ({
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+q" = "kill";
        "${alt}+F4" = "kill";

        "${modifier}+n" = "exec ${browser}";
        "${modifier}+m" = "exec ${fileManager}";

        "${modifier}+c" =
          "exec ${menu} -show calc -modi calc -no-show-match -no-sort";
        "${modifier}+d" = "exec ${menu} -show drun";
        "${modifier}+Tab" = "exec ${menu} -show window -modi window";

        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+v" = "split v";
        "${modifier}+b" = "split h";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+semicolon" = "focus mode_toggle";
        "${modifier}+Shift+semicolon" = "floating toggle";

        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "show scratchpad";

        "${modifier}+r" = ''mode "${resizeMode}"'';
        "${modifier}+Escape" = ''mode "${powerManagementMode}"'';
        "${modifier}+p" = ''mode "${displayLayoutMode}"'';

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        "XF86AudioRaiseVolume" =
          "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" =
          "exec --no-startup-id ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" =
          "exec --no-startup-id ${pactl}set-source-mute @DEFAULT_SOURCE@ toggle";

        "XF86MonBrightnessUp" = "exec --no-startup-id ${light} -A 5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id ${light} -U 5%";

        "XF86AudioPlay" = "exec --no-startup-id ${playerctl} play-pause";
        "XF86AudioStop" = "exec --no-startup-id ${playerctl} stop";
        "XF86AudioNext" = "exec --no-startup-id ${playerctl} next";
        "XF86AudioPrev" = "exec --no-startup-id ${playerctl} previous";

        "Print" = "exec --no-startup-id ${fullScreenShot}";
        "${modifier}+Print" = "exec --no-startup-id ${areaScreenShot}";
      } // (mapDirectionDefault {
        prefixKey = modifier;
        prefixCmd = "focus";
      }) // (mapDirectionDefault {
        prefixKey = "${modifier}+Shift";
        prefixCmd = "move";
      }) // (mapDirectionDefault {
        prefixKey = "Ctrl+${alt}";
        prefixCmd = "move workspace to output";
      }));

      modes = let
        exitMode = {
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      in {
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
        } // exitMode;
        ${resizeMode} = (mapDirection {
          leftCmd = "resize shrink width 10px or 10px";
          downCmd = "resize grow height 10px or 10px";
          upCmd = "resize shrink height 10px or 10px";
          rightCmd = "resize grow width 10px or 10px";
        }) // exitMode;
        ${powerManagementMode} = {
          l = "mode default, exec loginctl lock-session";
          e = "mode default, exec loginctl terminate-session $XDG_SESSION_ID";
          s = "mode default, exec systemctl suspend";
          h = "mode default, exec systemctl hibernate";
          "Shift+r" = "mode default, exec systemctl reboot";
          "Shift+s" = "mode fault, exec systemctl poweroff";
        } // exitMode;
      };

      workspaceAutoBackAndForth = true;
      workspaceLayout = "tabbed";

      window = {
        border = 1;
        hideEdgeBorders = "smart";
        titlebar = false;
      };

      focus = { followMouse = false; };

      startup = [
        {
          command = "${xset} s 600";
          notification = false;
        }
        {
          command = "${dex} --autostart";
          notification = false;
        }
      ];
    };

    # Until this issue is fixed we need to map workspaces directly to config file
    # https://github.com/nix-community/home-manager/issues/695
    extraConfig = builtins.concatStringsSep "\n" [
      (mapWorkspacesStr {
        inherit workspaces;
        prefixKey = modifier;
        prefixCmd = "workspace number";
      })
      (mapWorkspacesStr {
        inherit workspaces;
        prefixKey = "${modifier}+Shift";
        prefixCmd = "move container to workspace number";
      })
    ];
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
        Restart = "on-failure";
      };
    };

    xss-lock = {
      Unit = {
        Description = "Use external locker as X screen saver";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart =
          "${pkgs.xss-lock}/bin/xss-lock -s $XDG_SESSION_ID -l -- ${pkgs.lockscreen}/bin/lock-screen";
        Restart = "on-failure";
      };
    };
  };
}
