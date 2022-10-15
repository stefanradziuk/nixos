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
          # xournalpp tex support - TODO upstream?
          inherit (pkgs.texlive) scontents standalone varwidth;
        };

      in [
        acpilight
        cinnamon.nemo
        colorpicker
        diff-so-fancy
        difftastic
        direnv
        dunst
        exfat
        firefox
        fontpreview
        fzf
        gh
        gnumake
        google-chrome-beta
        gparted
        imagemagick
        kitty
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
        zathura
        zsh-prezto
        zsh-z

        coq

        teams
        xournalpp

        ffmpeg
        mpv
        youtube-dl

        cargo
        rust-analyzer
        rustc
        rustfmt

        zoom-us

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
