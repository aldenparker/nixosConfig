{
  pkgs,
  config,
  secrets,
  flake-inputs,
  system,
  ...
}:

let
  inherit (flake-inputs.self.packages.${system}) xnconvert; # Photo conversion app
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- Setup snowman modules (my custom modules)
  snowman = {
    hardware = {
      audio.enable = true;
      zsa.enable = true;
      asus-wmi-screenpad.enable = true;

      bluetooth = {
        enable = true;
        enableAudio = true;
      };

      nvidia-gpu = {
        enable = true;
        withCuda = true;
        prime = {
          enable = true;
          useSync = true;
          nvidiaBusId = "PCI:01:00:0";
          intelBusId = "PCI:00:02:0";
        };
      };
    };

    desktops.niri.enable = true;

    pkg-bundles = {
      cybersecurity.enable = true;
    };

    programs = {
      libreoffice.enable = true;
      steam.enable = true;
      virt-manager = {
        enable = true;
        users = [ "odin" ];
      };
    };

    services = {
      docker.enable = true;

      tailscale = {
        enable = true;
        loginServer = secrets.tailscale.loginServer;
        preAuthKey = secrets.tailscale.preAuthKey;
        operator = "odin";
      };

      cloudflared = {
        enable = true;
        tunnelToken = secrets.cloudflared.odinToken;
      };
    };
  };

  # --- Drawing Tablet Drivers
  boot.extraModulePackages = [ config.boot.kernelPackages.digimend ];

  # --- Packages without configuration
  environment.systemPackages = with pkgs; [
    retroarch-full
    scanmem
    anki
    kicad
    sparrow
    gephi
    ktailctl
    anytype
    simplex-chat-desktop
    solaar
    gittyup
    xnconvert
    vesktop
    pot # Japanese Study
    tagainijisho # Japanese Study
  ];

  # --- Enable printing
  services.printing.enable = true;

  # --- Fix clock for dual boot
  time.hardwareClockInLocalTime = true;

  # --- Use the grub EFI boot loader. WARNING: HERE BE DRAGONS
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # --- Add support for NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # --- Networking
  networking = {
    hostName = "odin"; # Define your hostname.
    networkmanager.enable = true; # Enable networkmanager

    # Enable firewall
    firewall.enable = true;
  };

  # Publish hostname to local network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # --- Localization Codes
  # Enable automatic time zone.
  services.automatic-timezoned.enable = true;

  # Select internationalization properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # --- User Settings
  # Define the user accounts
  users.users.odin = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
    ]; # Enable ‘sudo’ for the user and add network managing
  };

  # ---- NixOS Settings. WARNING: HERE BE DRAGONS
  system.stateVersion = "25.05";
}
