{
  pkgs,
  mkShell,
}:

# Create rust shell
mkShell {
  packages = with pkgs; [
    rustToolchain
    openssl
    pkg-config
    cargo-deny
    cargo-edit
    cargo-watch
    rust-analyzer
  ];

  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
  };
}
