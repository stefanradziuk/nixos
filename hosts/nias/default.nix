{...}:

{
  networking.hostName = "nias";
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/B926-17D7";
    fsType = "vfat";
  };
}
