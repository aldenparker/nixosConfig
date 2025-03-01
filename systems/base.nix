{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{
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
    killall
    vim
    wget
    curl
    git
    git-crypt
    nil
    nixfmt-rfc-style
  ];

  # --- Create installed packages file
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;
}
