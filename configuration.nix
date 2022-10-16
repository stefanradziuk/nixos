# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config
, home-manager
, lib
, pkgs
, ...
}:

let
  inherit (pkgs) callPackage;
  useXserver = true;
  mypkgs = pkgs.callPackage ./mypkgs {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      home-manager.nixosModule
    ];

  nixpkgs.config = import ./nixpkgs-config.nix;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        useOSProber = true;
        device = "nodev";
        efiSupport = true;
        splashImage = ./wallpapers/thonk.png;
        configurationLimit = 3;
      };
    };

    supportedFilesystems = [ "ntfs" ];
  };

  # TODO factor out device specific settings
  networking = {
    hostName = "ellsemere";
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networkmanager.dns = "none";
    nameservers = [ "1.1.1.1" "9.9.9.9" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  # console = {
  #   font = "Lat2-Terminus16";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = useXserver;

    displayManager = {
      startx.enable = true;
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = useXserver;
      package = pkgs.i3-gaps;
    };

    desktopManager = {
      xterm.enable = false;
    };

    autoRepeatDelay = 400;
    autoRepeatInterval = 25;

    # Configure keymap in X11
    layout = "gb,us,pl";
    xkbOptions = "grp:ctrls_toggle";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        gammastep
        clipman
        font-awesome
        glib
        grim
        lxappearance
        slurp
        sway-contrib.grimshot
        swayidle
        swaylock-effects
        waybar
        wev
        wl-clipboard
        mypkgs.rbql
      ];
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      extraConfig = ''
        run-shell ${pkgs.tmuxPlugins.resurrect.rtp}
        run-shell ${pkgs.tmuxPlugins.continuum.rtp}
        set -g @continuum-restore 'on'
      '';
    };

    light.enable = true;
    nm-applet.enable = true;
    zsh.enable = true;
  };

  services.logind.lidSwitch = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.stefan = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
  };

  home-manager.users.stefan = import ./stefan.nix;

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; (
      let
        python3 = pkgs.python3.withPackages (python-packages:
        with python-packages; [
          i3ipc
          ipython
          numpy
          pyyaml  # TODO do per-project derivations
          isort
          black
          jinja2
          mypkgs.rbql
        ] ++ (if useXserver then [
          i3-py
        ] else [])
        );

        polybar = pkgs.polybar.override {
          i3GapsSupport = true;
          pulseSupport = true;
        };
      in [
        bat
        exa
        fd
        feh
        file
        git
        htop
        jq
        killall
        mons
        neofetch
        neovim
        networkmanagerapplet
        nodejs
        pavucontrol
        pulsemixer
        python3
        ripgrep
        silver-searcher
        surfraw
        tree
        unzip
        vim
        wget
        xclip
      ] ++ lib.optionals useXserver [
        # redshift
        i3lock-color
        polybar
        scrot
        slop
        xbindkeys
      ]
    );

    sessionVariables = {
      # Wayland
      NIXOS_OZONE_WL = "1";
    };
  };

  fonts.fonts = with pkgs; [
    corefonts  # Microsoft fonts
    fira-code
    fira-code-symbols
    fira-mono
    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];
}
