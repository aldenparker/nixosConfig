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
      aflplusplus
      clang-tools
      gcc9
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
