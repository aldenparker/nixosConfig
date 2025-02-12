{
  description = "Snowman";

  inputs = {
    # NixPkgs and Unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware Configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake?ref=v1.4.1";
    flake.inputs.nixpkgs.follows = "unstable";

    # NVF for easy neovim setup
    nvf.url = "github:notashelf/nvf?ref=v0.7";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    let
      # Import all secrets used in config
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");

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
    lib.mkFlake
      {
        # Configure nixpkgs
        channels-config = {
          allowUnfree = true;
          permittedInsecurePackages = [];
        };

        # External overlay import
        overlays = with inputs; [];

        # External module import for all hosts
        systems.modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager
        ];

        # Pass special args to hosts
        systems.hosts.yggdrasil.specialArgs = {
          inherit secrets;
        };

        systems.hosts.heimdallur.specialArgs = {
          inherit secrets;
        };

        # External module import for all homes
        homes.modules = with inputs; [
          nvf.homeManagerModules.default
        ];

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