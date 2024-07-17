{ lib
, pkgs
, ...
}:

let
  google-chrome = import ../../common/google-chrome.nix {
    inherit lib pkgs;
    disableGpuVsync = true;
  };

in {
  networking.hostName = "ellesmere";
  imports = [
    ./hardware-configuration.nix
    ../../common/configuration.nix
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # https://nixos.wiki/wiki/Accelerated_Video_Playback
  hardware.graphics = {
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
    audacity
    google-chrome
    krita
    # vcv-rack
  ]);
}
