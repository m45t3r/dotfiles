{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    arandr
    arc-icon-theme
    arc-theme
    calibre
    chromium
    desktop-file-utils
    firefox
    gimp
    gnome3.adwaita-icon-theme
    gnome3.baobab
    gnome3.evince
    gnome3.file-roller
    gnome3.gnome-disk-utility
    gnome3.gnome-themes-standard
    gthumb
    gtk-engine-murrine
    hicolor-icon-theme
    inkscape
    insync
    keepassx-community
    kitty
    libreoffice-fresh
    lxappearance-gtk3
    lxmenu-data
    mcomix
    pcmanfm
    pavucontrol
    peek
    perlPackages.FileMimeInfo
    qalculate-gtk
    ranger
    redshift
    shared-mime-info
    termite
    unstable.spotify
    unstable.tdesktop
    xdotool
    xorg.xdpyinfo
    xorg.xkill
    xorg.xset
  ];

  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;

    fonts = with pkgs; [
      cantarell-fonts
      corefonts
      font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      ttf_bitstream_vera
      ubuntu_font_family
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Noto Mono" ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
      };
    };
  };

  hardware = {
    # Enable sound.
    pulseaudio.enable = true;
  };
}
