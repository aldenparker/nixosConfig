{ ... }: { 
  imports = [ 
    ./podman.nix
    ./tailscale.nix
    ./glance.nix 
    ./postgres.nix 
    ./gitea.nix 
  ]; 
}
