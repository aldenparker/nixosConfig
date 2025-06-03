{
  pkgs,
  system,
  flake-inputs,
}:

let
  mkShell = pkgs.mkShell;
in
{
  c-cpp = import ./c-cpp.nix {
    inherit pkgs;
    inherit mkShell;
    inherit system;
  };

  electron = import ./electron.nix {
    inherit pkgs;
  };

  jupyter = import ./jupyter.nix {
    inherit pkgs;
    inherit mkShell;
  };

  node = import ./node.nix {
    inherit pkgs;
    inherit mkShell;
  };

  python = import ./python.nix {
    inherit pkgs;
    inherit mkShell;
  };

  rust = import ./rust.nix {
    inherit pkgs;
    inherit mkShell;
  };

  zig-master = import ./zig-master.nix {
    inherit pkgs;
    inherit mkShell;
    inherit system;
    inherit flake-inputs;
  };

  zig-stable = import ./zig-stable.nix {
    inherit pkgs;
    inherit mkShell;
  };
}
