{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  # CLI packages.
  environment.systemPackages = with pkgs; [
    (mpv-with-scripts.override ({
      scripts = [ mpvScripts.mpris ];
    }))
    (python2Full.withPackages(ps: with ps; [ pip tkinter virtualenv ]))
    (python3Full.withPackages(ps: with ps; [ pip tkinter virtualenv ]))
    (neovim.override ({
      withNodeJs = true;
      vimAlias = true;
      viAlias = true;
    }))
    ag
    aria2
    bc
    bind
    cmus
    curl
    daemonize
    emacs
    fd
    file
    fzf
    gcc
    gitFull
    gnumake
    htop
    ispell
    jq
    lsof
    manpages
    mediainfo
    mosh
    mtr
    ncdu
    ncurses.dev
    netcat-gnu
    openssl
    p7zip
    pandoc
    parted
    pv
    python3Packages.youtube-dl
    ripgrep
    shellcheck
    sshuttle
    stow
    telnet
    tig
    tmux
    universal-ctags
    unrar
    unzip
    usbutils
    wget
    xclip
  ];

  # Fonts used in terminal.
  fonts = {
    fonts = with pkgs; [
      hack-font
      inconsolata
      powerline-fonts
      source-code-pro
      symbola
    ];
  };

  # Enable programs that need special configuration.
  programs = {
    iftop.enable = true;
    zsh.enable = true;
  };

  # Enable services.
  services = {
    cron.enable = true;
  };
}
