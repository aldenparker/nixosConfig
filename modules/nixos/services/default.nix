{ ... }: {
    tailscale = import ./tailscale.nix;
    glance = import ./glance.nix;
}
