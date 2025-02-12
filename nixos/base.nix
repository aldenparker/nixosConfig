{ inputs, outputs, lib, config, pkgs, ... }: {
  # --- Configure nixpkgs
  nixpkgs = {
    # Add overlays for host
    overlays = [
      # Add default overlays
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    # Allow unfree packages
    config = { allowUnfree = true; };
  };

  # --- Configure nix
  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features =
        "nix-command flakes"; # Enable flakes and new 'nix' command
      flake-registry = ""; # Disable global registry
    };

    channel.enable = false; # Disable channels to only use flakes

    # Make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # --- System Package Settings
  # Must have system packages to get anything done
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    git-crypt
    home-manager
  ];
}
