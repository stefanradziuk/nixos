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

      in [
        acpilight
        btop
        nemo
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
        hyprpicker
        inkscape
        lsof
        # wait for https://github.com/NixOS/nixpkgs/pull/211135/ to be released
        # kitty
        ncdu
        parallel
        psst
        pv
        qimgv # img viewer
        rofi-wayland
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
        zoxide
        zsh-prezto

        ghostscript_headless
        graphviz
        imagemagick

        gptfdisk

        starship

        diff-pdf

        # nvim plugins (TODO separate module?)
        tree-sitter
        texlab
        sumneko-lua-language-server
        haskell-language-server
        nodePackages.bash-language-server
        nodePackages.coc-pyright

        linuxPackages_latest.perf
        flamegraph

        graphviz

        ghc

        clang-tools

        pypy3

        ocaml
        ocamlPackages.utop
        emacs-gtk
        wabt
        rlwrap

        clingo

        # https://github.com/NixOS/nixpkgs/issues/240418
        # teams
        xournalpp
        discord
        zoom-us

        vscode-fhs

        ffmpeg
        mpv
        yt-dlp

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
