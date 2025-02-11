{
  description = "1024bit's NixOS Config";

  inputs = {
    # Both the stable and unstable version of Nix is needed
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # Home-manager to use with home folders and user configs
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NVF for easy vim setup
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nvf, ... }@inputs:
    let
      inherit (self) outputs;

      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Import all secrets used in config
      secrets =
        builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    in {
      # Custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

      # Formatter for your nix files, available through 'nix fmt'
      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Reusable system level nixos modules. This stuff can be configured, but is never user specific.
      nixosModules = import ./modules/nixos;

      # Reusable user level home-manager modules. This stuff can be configured, but is never user specific.
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#hostname' or the alias 'nix-up'
      nixosConfigurations = {
        yggdrasil = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./nixos/yggdrasil/configuration.nix ];
        };

        heimdallur = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs secrets; };
          modules = [ ./nixos/heimdallur/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#username' or the alias 'home-up'
      homeConfigurations = {
        "yggdrasil" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs secrets nvf; };
          modules = [ ./home-manager/yggdrasil/home.nix ];
        };

        "heimdallur" = home-manager.lib.homeManagerConfiguration {
          pkgs =
            nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs secrets nvf; };
          modules = [ ./home-manager/heimdallur/home.nix ];
        };
      };
    };
}

