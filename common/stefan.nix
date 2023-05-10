{ lib
, pkgs
, mypkgs
, ...
}:

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
    file = mapDir ../dots;

    packages = with pkgs; (
      let
        st = pkgs.st.overrideAttrs (oldAttrs: rec {
          configFile = ../patches/st/config.def.h;
          patches = [
            (fetchpatch {
              url = "https://st.suckless.org/patches/bold-is-not-bright/st-bold-is-not-bright-20190127-3be4cf1.diff";
              sha256 = "sha256-IhrTgZ8K3tcf5HqSlHm3GTacVJLOhO7QPho6SCGXTHw=";
            })
          ];
          postPatch = oldAttrs.postPatch + ''
            cp ${configFile} config.def.h
          '';
        });

        texlive = pkgs.texlive.combined.scheme-full;

        # waiting for github.com/junegunn/fzf/issues/3235 to be released
        fzf = pkgs.fzf.overrideAttrs (_: {
          version = "pre-0.40.0";
          src = fetchFromGitHub {
            owner = "junegunn";
            repo = "fzf";
            rev = "f1a96296525975ea7d4c45aebc4fed5117cecb72";
            hash = "sha256-7e4jC/Lm+nZ9u8hG/Fcls3eIctzIU7qJh78qkmKoko4=";
          };
        });

      in [
        acpilight
        cinnamon.nemo
        colorpicker
        ccrypt
        ddcutil
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
        gparted
        helix
        imagemagick
        inkscape
        lsof
        # wait for https://github.com/NixOS/nixpkgs/pull/211135/ to be released
        # kitty
        ncdu
        parallel
        psst
        pv
        rofi
        rofimoji
        shellcheck
        slack
        spotify
        st
        texlive
        wtype
        xdotool
        xorg.xeyes
        zathura
        zip
        zsh-prezto
        zsh-z

        # nvim plugins (TODO separate module?)
        tree-sitter
        texlab
        coqPackages.coq-lsp
        sumneko-lua-language-server
        haskell-language-server
        nodePackages.bash-language-server

        linuxPackages_latest.perf
        flamegraph

        graphviz

        ghc

        pypy3

        coq
        ocaml
        ocamlPackages.utop
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

        qcachegrind
        qdirstat

        mypkgs.i3-scripts

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
        # (import ../my-pkgs/autorandr-rs.nix)
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
