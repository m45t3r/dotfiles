{ config, pkgs, ... }:

{
  # CLI packages.
  environment.systemPackages = with pkgs; [
    any-nix-shell
    aria2
    bc
    bind
    cachix
    curl
    dos2unix
    fd
    ffmpeg
    ffmpegthumbnailer
    file
    fzf
    gettext
    ghostscript
    glxinfo
    graphicsmagick-imagemagick-compat
    htop
    ispell
    jq
    libnotify
    linuxPackages.cpupower
    lm_sensors
    lshw
    lsof
    manpages
    mediainfo
    moreutils
    ncdu
    netcat-gnu
    nnn
    nox
    openssl
    p7zip
    page
    pandoc
    pciutils
    playerctl
    powertop
    psmisc
    pv
    python3Packages.youtube-dl
    ripgrep
    screenkey
    sloccount
    sshuttle
    stow
    sxiv
    tealdeer
    telnet
    tig
    tmux-with-systemd
    universal-ctags
    unrar
    unstable.each
    unzip
    usbutils
    wget
    wmctrl
    xclip
    zip
  ];

  # Fonts used in terminal.
  fonts = {
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      inconsolata
      iosevka
      powerline-fonts
      source-code-pro
      symbola
    ];
  };

  # Enable programs that need special configuration.
  programs = {
    iftop.enable = true;
    mtr.enable = true;
    zsh = {
      enable = true;
      interactiveShellInit = with pkgs; ''
        source "''$(${fzf}/bin/fzf-share)/key-bindings.zsh"
      '';
      promptInit = ''
        any-nix-shell zsh --info-right | source /dev/stdin
      '';
    };
  };
}
