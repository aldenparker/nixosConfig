{ ... }:

{
  imports = [
    ./cloudflared.nix
    ./docker.nix
    ./filebrowser.nix
    ./gitea.nix
    ./glance.nix
    ./podman.nix
    ./postgres.nix
    ./tailscale.nix
  ];
}
