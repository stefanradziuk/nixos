{...}:

{
  networking.hostName = "nias";
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B926-17D7";
    fsType = "vfat";
  };

  boot.loader.grub.useOSProber = true;
}
