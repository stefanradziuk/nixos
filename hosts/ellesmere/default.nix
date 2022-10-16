{...}:

{
  networking.hostName = "ellesmere";
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
}
