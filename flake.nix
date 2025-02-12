{
  description = "1024bit's NixOS Config";

  inputs = {
    # Both the stable and unstable version of Nix is needed
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # Import flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = { self, flake-parts, ... }@inputs:
    let
      # Grab outputs to pass to modules
      inherit (self) outputs;

      # Import all secrets used in config
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");

    in flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        
      ];

      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      perSystem = { config, pkgs, system, ... }: {
        # Set correct version of pkgs and add unstable
        _module.args.pkgs = import self.inputs.nixpkgs { 
          inherit system; 

          overlays = [
            (final: _prev: {
              unstable = import inputs.nixpkgs-unstable {
                system = final.system;
                config.allowUnfree = true;
              };
            })
          ]; 

          config.allowUnfree = true; 
        };

        # Formatter for your nix files, available through 'nix fmt'
        formatter = pkgs.nixfmt;

        # Setup home-manager configurations
        packages.homeConfigurations = {
            "yggdrasil" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs outputs secrets nvf; };
              modules = [ ./home-manager/yggdrasil/home.nix ];
            };

            "heimdallur" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = { inherit inputs outputs secrets nvf; };
              modules = [ ./home-manager/heimdallur/home.nix ];
            };
          };
        };

        flake = {
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
        };
    };
}

