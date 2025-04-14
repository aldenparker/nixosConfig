{
  system,
  pkgs,
  mkShell,
  ...
}:

# Create c / cpp shell
let
  gcc9_multi = pkgs.wrapCCMulti pkgs.gcc9;
in
mkShell {
  packages =
    with pkgs;
    [
      clang-tools
      gcc9_multi
      cmake
      codespell
      conan
      cppcheck
      doxygen
      gtest
      lcov
      vcpkg
      vcpkg-tool
      qemu
      bear
    ]
    ++ (if system == "aarch64-darwin" then [ ] else [ gdb ]);
}
