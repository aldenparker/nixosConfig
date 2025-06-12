{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_emoji";
  version = "0.13.0";

  src = fetchFromGitHub {
    repo = "nu_plugin_emoji";
    owner = "fdncred";
    rev = "v${version}";
    hash = "sha256-PC6ALLp/PWDbtoxMfx3JuEJXvRm1a49k7+I1L0sDdN8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BFWFmTQvqJXUZ2bYBsVNt6ErkCAls0R5HMah7VWZcCQ=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin that makes finding and printing emojis easy in nushell.";
    mainProgram = "nu_plugin_emoji";
    homepage = "https://github.com/fdncred/nu_plugin_emoji";
    license = licenses.mit;
    # maintainers = with maintainers; [ aldenparker ];
    platforms = platforms.all;
  };
}
