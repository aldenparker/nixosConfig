{ inputs, lib, config, pkgs, ... }: {
  # Enable flakes 
  nix.settings.experimental-features = "nix-command flakes"; 

  # Set flake session variable for nh programs
  environment.sessionVariables = {
    FLAKE = "/etc/nixos";
  };

  # --- System Package Settings
  # Must have system packages to get anything done
  environment.systemPackages = with pkgs; [
    nh
    vim
    wget
    curl
    git
    git-crypt
  ];

  # Setup hyprland cache
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
