{
  pkgs,
  mkShell,
  ...
}:

# Creates python3 shell with venv (jupyter edition)
mkShell {
  venvDir = ".venv";
  packages = with pkgs; [ poetry python311 ] ++ (with python311Packages; [
    ipykernel
    pip
    venvShellHook
  ]);
}