{ pkgs, ... }:

{
  # For Slack.
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    aws
    leiningen
    nodejs-10_x
    openfortivpn
    openssl
    slack
  ];

  # Enable Java.
  programs.java = {
    enable = true;
    package = [
      jdk8
      jre8
    ];
  };

  # Enable FortiSSL VPN support in NetworkManager.
  networking.networkmanager = {
    packages = [
      pkgs.networkmanager-fortisslvpn
    ];
  };

  # Enable Docker.
  virtualisation.docker.enable = true;

  # Enable VirtualBox.
  virtualisation.virtualbox.host.enable = true;

  users.users.thiagoko.extraGroups = [ "docker" "vboxusers" ];
}
