{ lib, pkgs, ... }:
let
  mapDir = dir: let
    mapToAttrs = f: list: builtins.listToAttrs (map f list);

    removePathPrefix = prefix: path: ".${lib.removePrefix (toString prefix) (toString path)}";

    pathToXdgAttr = path: {
      name = removePathPrefix dir path;
      value = {
        source = path;
      };
    };

    paths = lib.filesystem.listFilesRecursive dir;
  in mapToAttrs pathToXdgAttr paths;

in {
  nixpkgs.config = import ./nixpkgs-config.nix;

  programs.home-manager.enable = true;

  home = {
    stateVersion = "21.11";
    file = mapDir ./home-dots;

    packages = with pkgs; (
      let
        google-chrome-beta = pkgs.google-chrome-beta.override {
          commandLineArgs = [
            "--force-dark-mode"
            "--enable-features=WebUIDarkMode"
          ];
        };

        st = pkgs.st.overrideAttrs (oldAttrs: rec {
          configFile = ./patches/st/config.def.h;
          postPatch = oldAttrs.postPatch + ''
            cp ${configFile} config.def.h
          '';
        });

        # TODO nix env for tex projects
        texlive = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-medium titlesec fira fontaxes enumitem;
        };

      in [
        acpilight
        cinnamon.nemo
        diff-so-fancy
        direnv
        dunst
        exfat
        firefox
        fzf
        gh
        gnumake
        google-chrome-beta
        gparted
        imagemagick
        kitty
        mpv
        nodePackages.bash-language-server
        psst
        rofi
        rofimoji
        shellcheck
        slack
        spotify
        st
        texlive
        wtype
        xdotool
        youtube-dl
        zathura
        zsh-prezto
        zsh-z

        cargo
        rust-analyzer
        rustc
        rustfmt

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
  };
}
