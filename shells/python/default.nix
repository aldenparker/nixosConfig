{
  pkgs,
  mkShell,
  ...
}:

# Creates python3 shell with venv
mkShell {
  venvDir = ".venv";
  packages =
    with pkgs;
    [
      poetry
      python311
    ]
    ++ (with python311Packages; [
      pip
      venvShellHook
    ]);
}
