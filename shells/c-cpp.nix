{
  system,
  pkgs,
  mkShell,
}:

# Create c / cpp shell
mkShell {
  packages =
    with pkgs;
    [
      clang-tools
      gcc14
      cmake
      codespell
      conan
      cppcheck
      doxygen
      gtest
      lcov
      vcpkg
      vcpkg-tool
    ]
    ++ (if system == "aarch64-darwin" then [ ] else [ gdb ]);
}
