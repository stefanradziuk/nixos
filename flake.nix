{
  inputs = {
    # pinned back from "github:nixos/nixpkgs/nixos-unstable" because of a bad mupdf/zathura update
    nixpkgs.url = "github:stefanradziuk/nixpkgs/chrome-flag-order";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.ellsemere = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}

