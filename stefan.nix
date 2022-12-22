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
    file = mapDir ./dots;

    packages = with pkgs; (
      let
        google-chrome-beta = pkgs.google-chrome-beta.override {
          commandLineArgs = [
            "--force-device-scale-factor=1.0"
            "--password-store=basic"
            "--force-dark-mode"
            "--enable-features=WebUIDarkMode"
          ];
        };

        google-chrome = pkgs.google-chrome.override {
          commandLineArgs = [
            "--force-device-scale-factor=1.0"
            "--password-store=basic"
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

        texlive = pkgs.texlive.combined.scheme-full;
        # TODO nix env for tex projects
        # texlive = pkgs.texlive.combine {
        #   inherit (pkgs.texlive) scheme-medium titlesec fira fontaxes enumitem svg svgcolor svg-inkscape;
        #   # xournalpp tex support - TODO upstream?
        #   inherit (pkgs.texlive) scontents standalone varwidth;
        # };

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
        gcc
        gh
        gnumake
        google-chrome
        google-chrome-beta
        gparted
        helix
        imagemagick
        inkscape
        kitty
        nodePackages.bash-language-server
        parallel
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
        zip
        zsh-prezto
        zsh-z

        vcv-rack
        audacity

        ghc
        haskell-language-server

        pypy3

        coq

        teams
        xournalpp
        discord
        zoom-us

        vscode-fhs

        ffmpeg
        mpv
        youtube-dl

        rclone

        cargo
        rust-analyzer
        rustc
        rustfmt

        # kidneycaliper stuff
        blas
        lapack
        openslide
        vips

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
