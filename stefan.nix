{ lib, pkgs, ... }: {
  nixpkgs.config = import ./nixpkgs-config.nix;

  home.stateVersion = "21.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; (
    let
      google-chrome-beta = pkgs.google-chrome-beta.override {
        commandLineArgs = [
          "--force-dark-mode"
          "--enable-features=WebUIDarkMode"
        ];
      };
    in [
      acpilight
      cinnamon.nemo
      dunst
      exfat
      firefox
      gh
      google-chrome-beta
      gparted
      imagemagick
      kitty
      rofi
      rofimoji
      slack
      spotify
      zathura
      zsh-prezto
      zsh-z

      # theming
      gnome-themes-extra
      gsettings-desktop-schemas
      gtk-engine-murrine
      gtk_engines
      la-capitaine-icon-theme
      lxappearance
      phinger-cursors
      # autorandr?
      # (import ./my-pkgs/autorandr-rs.nix)
    ]
  );

  xdg.configFile = let
    mapToAttrs = f: list: builtins.listToAttrs (map f list);

    removePathPrefix = prefix: path: ".${lib.removePrefix (toString prefix) (toString path)}";

    pathToXdgAttr = path: {
      name = removePathPrefix ./config path;
      value = {
        source = path;
      };
    };

    configPaths = lib.filesystem.listFilesRecursive ./config;

  in mapToAttrs pathToXdgAttr configPaths;
}
