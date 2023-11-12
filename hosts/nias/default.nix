{ lib
, pkgs
, ...
}:

let
  google-chrome = import ../../common/google-chrome.nix { inherit lib pkgs; };

in {
  networking.hostName = "nias";
  imports = [
    ./hardware-configuration.nix
    ../../common/configuration.nix
  ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B926-17D7";
    fsType = "vfat";
  };

  home-manager.users.stefan.home.packages = [ google-chrome ];
}
