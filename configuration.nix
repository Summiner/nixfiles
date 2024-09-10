# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./modules/nix.nix
    ./modules/sound
    ./fonts.nix
    ./modules/git.nix
    ./modules/steam.nix
    ./modules/vscode.nix
    ./modules/jetbrains.nix
    ./modules/js.nix
    ./modules/java.nix
    ./modules/obs.nix
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    sandbox = true;
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.supportedFilesystems = [ "ntfs" ];
  virtualisation.waydroid.enable = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.extraHosts =
    ''
      0.0.0.0 accounts.jetbrains.com account.jetbrains.com www-weighted.jetbrains.com
    '';

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  #.x.enable = true;
  programs.xwayland.enable = true;
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.defaultSession = "gnome";

  # systemd.services."user@1000".serviceConfig.LimitNOFILE = "32768";
  # security.pam.loginLimits = [
  #   {
  #     domain = "*";
  #     item = "nofile";
  #     type = "-";
  #     value = "32768";
  #   }
  #   {
  #     domain = "*";
  #     item = "memlock";
  #     type = "-";
  #     value = "32768";
  #   }
  # ];


  # Enable KDE
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  programs.dconf.enable = true;
  
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # services.printing.drivers = with pkgs; [
  #   postscript-lexmark
  # ];

  # Enable sound.
  #sound.enable = true;
  #services.pipewire.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  cookiecutie.sound.pipewire.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jamie = {
    isNormalUser = true;
    createHome = true;
    extraGroups = ["wheel" "input" "adbusers" "plugdev" "docker" "dialout"]; # Enable ‘sudo’ for the user.
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.polkit.enable = true;

  home-manager.users.jamie = {
    config,
    lib,
    ...
  }: {
    home.stateVersion = "23.05";

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };

    home.packages = with pkgs; [
      thunderbird
      vesktop
      mako
      termius
      inkscape-with-extensions
      xorg.xeyes
      (prismlauncher.override {withWaylandGLFW = true;}) #yoink, thanks uriel
      element-desktop
      mpv
      qbittorrent
      spotify-qt
      spotify
      appimage-run
      flatpak-builder
      python3Full
      python310Packages.toml
      python310Packages.aiohttp
      gimp
      # old electron in EoL
      r2modman
      imv
      dotnet-sdk_7
      mono
      fuse
      ntfs3g
      mitmproxy
      screen
      unrar
      aseprite
      godot_4
      gnupg
      monero-gui
      fritzing
    ];

    services.easyeffects.enable = true;

    home.sessionVariables = {
      MESA_DISK_CACHE_SINGLE_FILE = "1";
    };

    # dconf.settings = {
    #   "org/gnome/desktop/input-sources" = {
    #     show-all-sources = true;
    #     sources = [
    #       (lib.hm.gvariant.mkTuple ["xkb" "us+altgr-intl"])
    #       (lib.hm.gvariant.mkTuple ["xkb" "latam"])
    #     ];
    #     xkb-options = ["terminate:ctrl_alt_bksp"];
    #   };
    #   "org/gnome/shell" = {
    #     disable-user-extensions = false;

    #     # `gnome-extensions list` for a list
    #     enabled-extensions = [
    #       "appindicatorsupport@rgcjonas.gmail.com"
    #     ];
    #   };
    # };

    qt.platformTheme = "kde";

    programs.direnv.enable = true;
    programs.direnv.enableBashIntegration = true;
    programs.bash.enable = true;

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
  # programs.cnping.enable = true;

  services.flatpak.enable = true;
  cookiecutie.git.enable = true;
  uri.steam.enable = true;
  uri.vscode.enable = true;
  uri.jetbrains.enable = true;
  uri.java.enable = true;
  uri.javascript.enable = true;
  uri.obs.enable = true;
  programs.adb.enable = true;
  programs.nix-ld.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  # programs.git.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    radeontop
    libreoffice-qt
    (firefox-wayland.override {
      nativeMessagingHosts = [
        inputs.pipewire-screenaudio.packages.${pkgs.system}.default
        pkgs.kdePackages.plasma-browser-integration
        pkgs.fx-cast-bridge
      ];
    })
    nano
    neovim
    wget
    tree
    neofetch
    killall
    htop
    file
    inetutils
    binutils-unwrapped
    psmisc
    pciutils
    usbutils
    dig
    ripgrep # a better grep
    unzip
    ncdu_1 # _2 only supports modern microarchs
    fd # a better find
    hyperfine # a better time
    mtr # a better traceroute
    tilix
    yt-dlp # do some pretendin' and fetch videos
    btop # htop on steroids
    nix-tree # nix what-depends why-depends who-am-i
    libayatana-appindicator
    wl-clipboard
    wev
    wl-mirror
    wl-color-picker
    # gnomeExtensions.appindicator
    # gnome.gnome-tweaks
    nvtopPackages.amd
    remmina
    vulkan-headers
    vulkan-loader
    vulkan-tools
    pavucontrol
    docker-compose
    # distrobox
    kdePackages.kdeconnect-kde
    kdePackages.kleopatra

    # wine-staging (version with experimental features)
    # wineWowPackages.staging
    # winetricks (all versions)
    winetricks
    # native wayland support (unstable)
    wineWowPackages.waylandFull
    dxvk
    protontricks

    pkgsi686Linux.gperftools

    python312Packages.torchWithRocm

    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    libGL
  ];

  # services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  services.upower.enable = true;

  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      # gtkUsePortal = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;
  services.fwupd.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # this file is not created and it's required for networkmanager ipsec
  environment.etc = {
    "ipsec.secrets".text = ''
      include ipsec.d/ipsec.nm-l2tp.secrets
    '';
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "unstable"; # Did you read the comment?
}
