{ pkgs, ... }: {
  nixpkgs.config = import ./nixpkgs-config.nix;

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
      gh
      google-chrome-beta
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
}
