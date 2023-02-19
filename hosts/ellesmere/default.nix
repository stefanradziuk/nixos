{ pkgs, ... }:

{
  networking.hostName = "ellesmere";
  imports = [ ./hardware-configuration.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # https://nixos.wiki/wiki/Accelerated_Video_Playback
  hardware.opengl = {
    enable = true;
    # XXX are any of these redundant?
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  programs.steam.enable = true;

  home-manager.users.stefan.home.packages = (with pkgs; [
    vcv-rack
    audacity
  ]);
}
