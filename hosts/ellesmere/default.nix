{...}:

{
  networking.hostName = "ellesmere";
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  home-manager.users.stefan.home.packages = [
    vcv-rack
    audacity
  ];
}
