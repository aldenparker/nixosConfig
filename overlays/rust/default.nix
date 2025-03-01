{ channels, ... }: 

_final: _prev:
{
  rustToolchain =
  let
    rust = _prev.rust-bin;
  in
  if builtins.pathExists ./rust-toolchain.toml then
    rust.fromRustupToolchainFile ./rust-toolchain.toml
  else if builtins.pathExists ./rust-toolchain then
    rust.fromRustupToolchainFile ./rust-toolchain
  else
    rust.stable.latest.default.override {
      extensions = [ "rust-src" "rustfmt" ];
    };
}
