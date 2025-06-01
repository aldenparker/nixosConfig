{
  description = "Snowman";

  inputs = {
    # NixPkgs and Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware Configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixos ASUS-WMI-SCREENPAD driver
    asus-wmi-screenpad = {
      url = "github:MatthewCash/asus-wmi-screenpad-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    asus-wmi-screenpad-ctl.url = "github:aldenparker/asus-wmi-screenpad-ctl";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Lib
    snowfall-lib = {
      url = "github:snowfallorg/lib?ref=v3.0.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NVF for easy neovim setup
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix
    stylix.url = "github:danth/stylix/release-25.05";

    # Plasma Manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Program to help with adding zsh support in nix shells and nix develop
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zig overlays
    zig-overlay.url = "github:mitchellh/zig-overlay";
    zls-overlay.url = "github:zigtools/zls";

    # Niri
    niri.url = "github:sodiboo/niri-flake";

    # Zen Browser
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs =
    inputs:
    let
      # Import all secrets used in config
      secrets = builtins.fromJSON (builtins.readFile "${inputs.self}/secrets/secrets.json");

      # Setup internal library
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "snowman";
            title = "Snowman";
          };

          namespace = "snowman";
        };
      };
    in
    # Setup flake
    lib.mkFlake {
      # Configure nixpkgs
      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [ ];
      };

      # External overlay import
      overlays = with inputs; [
        nix-your-shell.overlays.default
        rust-overlay.overlays.default
        niri.overlays.niri
        asus-wmi-screenpad-ctl.overlays.default
      ];

      # External module import for all hosts
      systems.modules.nixos = with inputs; [
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
      ];

      # Pass special args to hosts
      systems.hosts.odin.specialArgs = {
        inherit secrets;
      };

      systems.hosts.yggdrasil.specialArgs = {
        inherit secrets;
      };

      systems.hosts.heimdallur.specialArgs = {
        inherit secrets;
      };

      # External module import for all homes
      homes.modules = with inputs; [
        nvf.homeManagerModules.default
        stylix.homeModules.stylix
        plasma-manager.homeManagerModules.plasma-manager
      ];

      homes.users."odin@odin".specialArgs = {
        inherit secrets;
      };

      homes.users."yggdrasil@yggdrasil".specialArgs = {
        inherit secrets;
      };

      homes.users."heimdallur@heimdallur".specialArgs = {
        inherit secrets;
      };

      # Import hardware packages for raspberry pi into the heimdallur device config
      systems.hosts.heimdallur.modules = with inputs; [
        nixos-hardware.nixosModules.raspberry-pi-3
      ];
    }
    // {
      self = inputs.self;
    };
}
