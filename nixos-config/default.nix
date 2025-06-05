{
  config,
  pkgs,
  ...
}:

{
  # --- Enable flakes
  nix.settings.experimental-features = "nix-command flakes";

  # --- Set flake session variable for nh programs
  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };

  # --- System Package Settings
  # Must have system packages for all devices
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
    nix-tree
    moreutils
  ];

  programs.htop = {
    enable = true;
    settings.show_cpu_temperature = 1;
  };

  # --- Install zsh, since this is the only shell I use
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # --- Create installed packages file
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;
}
