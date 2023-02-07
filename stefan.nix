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

        discord = pkgs.discord.overrideAttrs (_: rec {
          version = "0.0.22";
          src = fetchurl {
            url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
            sha256 = "sha256-F1xzdx4Em6Ref7HTe9EH7whx49iFc0DFpaQKdFquq6c=";
          };
        });

      in [
        acpilight
        cinnamon.nemo
        colorpicker
        diff-so-fancy
        difftastic
        direnv
        dunst
        exfat
        figlet
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
        lsof
        # wait for https://github.com/NixOS/nixpkgs/pull/211135/ to be released
        # kitty
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
        ocaml
        emacs-gtk
        agda
        wabt
        rlwrap

        clingo

        teams
        xournalpp
        discord
        zoom-us

        vscode-fhs

        ffmpeg
        mpv
        youtube-dl

        sshfs
        rclone

        cargo
        rust-analyzer
        rustc
        rustfmt

        qdirstat

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

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };
}
