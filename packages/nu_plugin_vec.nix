{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
  writeText,
}:

let
  lock-diff = writeText "lock.diff" ''
    diff --git a/Cargo.lock b/Cargo.lock
    index 6a448e2..5b194cd 100644
    --- a/Cargo.lock
    +++ b/Cargo.lock
    @@ -604,11 +604,10 @@ dependencies = [

     [[package]]
     name = "lscolors"
    -version = "0.20.0"
    +version = "0.17.0"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "61183da5de8ba09a58e330d55e5ea796539d8443bd00fdeb863eac39724aa4ab"
    +checksum = "53304fff6ab1e597661eee37e42ea8c47a146fca280af902bb76bff8a896e523"
     dependencies = [
    - "aho-corasick",
      "nu-ansi-term",
     ]

    @@ -722,28 +721,13 @@ dependencies = [
      "windows-sys 0.52.0",
     ]

    -[[package]]
    -name = "nu-cmd-base"
    -version = "0.105.1"
    -source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "5a9dd15151455f8c7f8e1594ddfcb8a6bdf7584e7a8bc92e30fe97e70cc1efdc"
    -dependencies = [
    - "indexmap",
    - "miette",
    - "nu-engine",
    - "nu-parser",
    - "nu-path",
    - "nu-protocol",
    -]
    -
     [[package]]
     name = "nu-cmd-lang"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "12bf3827e34ad220272f85c3453d7344267d7fc8bad18ed8376ae16dc2667e42"
    +checksum = "51ce2833dcdb4852b2c620028025e93f6514fbd98b2e5eced3a9731df70fd163"
     dependencies = [
    - "itertools 0.14.0",
    - "nu-cmd-base",
    + "itertools 0.13.0",
      "nu-engine",
      "nu-parser",
      "nu-protocol",
    @@ -753,9 +737,9 @@ dependencies = [

     [[package]]
     name = "nu-derive-value"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "4ee0c44272959c27c3df00eca860fae47c2ecc90e8db403f65ba40cd9a288f90"
    +checksum = "bb228dcc0e261df58969c33e25ab386f6aade3cdf7576c2c090f1246759a39f3"
     dependencies = [
      "heck",
      "proc-macro-error2",
    @@ -766,9 +750,9 @@ dependencies = [

     [[package]]
     name = "nu-engine"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "c17cc6e45c96465bcdd49fa7fd0e694a46d4122dcd0df3c989bf5c52d4949f88"
    +checksum = "5bf76503061ed987aa256da8b2c7bf362362e83ed2b6af1d3923244803c5eba2"
     dependencies = [
      "log",
      "nu-glob",
    @@ -779,19 +763,19 @@ dependencies = [

     [[package]]
     name = "nu-glob"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "45887876f9a0f0045fa9fa29904753015b312481df5918b53f995876c524d420"
    +checksum = "c462e5b22f4192b7d03e646475320566a829474b5749d881b57ca5c4fd391726"

     [[package]]
     name = "nu-parser"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "191b2e3c93dc337238e805ca1204bdb853f9dbfe561124c7ac49f24e904f9c08"
    +checksum = "997c522804c98ed56bb339a6099789751fcf7d769e264c64a65338702d0b4997"
     dependencies = [
      "bytesize",
      "chrono",
    - "itertools 0.14.0",
    + "itertools 0.13.0",
      "log",
      "nu-engine",
      "nu-path",
    @@ -803,9 +787,9 @@ dependencies = [

     [[package]]
     name = "nu-path"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "92db87b383c439d7c49987e716c9b3ee9144d89b0977e3b650f29d1ada57fdd4"
    +checksum = "2ee58f1ff961241050402dd069652a4b778c392861f56414192c3d50a5ed83c6"
     dependencies = [
      "dirs",
      "omnipath",
    @@ -815,9 +799,9 @@ dependencies = [

     [[package]]
     name = "nu-plugin"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "0ab3d957698e510b8fe728694a6d31a7b0c54e8be0863a18d1f1e74d54381c87"
    +checksum = "95c85a0cee2731b5bc6d57d9eff91242c4c6e8b9b82f9e1a1441a2595856133f"
     dependencies = [
      "log",
      "nix",
    @@ -831,9 +815,9 @@ dependencies = [

     [[package]]
     name = "nu-plugin-core"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "158c7caf83fd981484374f30ba60cade2c6b7b32d33f32af55803991a3ac5718"
    +checksum = "162ec78caca414bf4b51c0a5a656f4263523a074afe21842c135ab43c28508a5"
     dependencies = [
      "interprocess",
      "log",
    @@ -847,9 +831,9 @@ dependencies = [

     [[package]]
     name = "nu-plugin-engine"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "9065a04878bce574db07b1cdaaea60160492b57c869d296a716d78fbf7b48a14"
    +checksum = "c7a1b777c98f169df90517d07337eb24490a5d778454dc502b80c16083a25a1a"
     dependencies = [
      "log",
      "nu-engine",
    @@ -864,9 +848,9 @@ dependencies = [

     [[package]]
     name = "nu-plugin-protocol"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "8c4df83ad66bfb42d67e2b39cf44551a6be26b8d38bfc6ee7c145039a0b88495"
    +checksum = "9888b3c1c2303c72d7948033e4cbc6a5fbb3e26b56e733a05abe5e5e2c97c00d"
     dependencies = [
      "nu-protocol",
      "nu-utils",
    @@ -878,9 +862,9 @@ dependencies = [

     [[package]]
     name = "nu-plugin-test-support"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "3160cea448216250ef6fd46424e7c862fc86770d0c54fa37797ac1f6ff3b455b"
    +checksum = "bc2c60d375f65e55ee655bd2168c2df612fd94e31037f14aa41f013a23f46eee"
     dependencies = [
      "nu-ansi-term",
      "nu-cmd-lang",
    @@ -896,9 +880,9 @@ dependencies = [

     [[package]]
     name = "nu-protocol"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "5abdee3bae72a90a4e83835daa2d442e8591871aa198a19e740f7611677fbe1d"
    +checksum = "5c31bba47cb82866f53f079a064a2c233baa70c715f835949fa1bf4ca861ba96"
     dependencies = [
      "brotli",
      "bytes",
    @@ -929,18 +913,17 @@ dependencies = [
      "thiserror 2.0.12",
      "typetag",
      "web-time",
    - "windows 0.56.0",
      "windows-sys 0.48.0",
     ]

     [[package]]
     name = "nu-system"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "674150d82c32c4ef6bb8c8cf2d39c55c3eccb950776dedb63f9411c09bf71907"
    +checksum = "8fb363919986bdb5d9c4c093e9da19c73889d6016f0d49374a388364ca24edaf"
     dependencies = [
      "chrono",
    - "itertools 0.14.0",
    + "itertools 0.13.0",
      "libc",
      "libproc",
      "log",
    @@ -955,9 +938,9 @@ dependencies = [

     [[package]]
     name = "nu-utils"
    -version = "0.105.1"
    +version = "0.104.1"
     source = "registry+https://github.com/rust-lang/crates.io-index"
    -checksum = "0d08d170760c40be43e32034048338099137760ab9e242fc9dce30f2e8955175"
    +checksum = "97b2caee79fc55090fb10d35c81f8f52ec6bed96961bde357bf31b23ca378a8e"
     dependencies = [
      "crossterm",
      "crossterm_winapi",
    @@ -975,7 +958,7 @@ dependencies = [

     [[package]]
     name = "nu_plugin_vec"
    -version = "1.1.5"
    +version = "1.1.6"
     dependencies = [
      "itertools 0.14.0",
      "nu-plugin",
  '';
  toml-diff = writeText "toml.diff" ''
    diff --git a/Cargo.toml b/Cargo.toml
    index 8e637ca..2b315c9 100644
    --- a/Cargo.toml
    +++ b/Cargo.toml
    @@ -9,9 +9,9 @@ readme = "README.md"
     version = "1.1.6"

     [dependencies]
    -nu-plugin = "0.105.1"
    -nu-protocol = "0.105.1"
    +nu-plugin = "0.104.0"
    +nu-protocol = "0.104.0"
     itertools = "0.14.0"

     [dev-dependencies]
    -nu-plugin-test-support = { version = "0.105.1" }
    \ No newline at end of file
    +nu-plugin-test-support = "0.104.0"
  '';
  version = "1.1.6";
in
rustPlatform.buildRustPackage {
  pname = "nu_plugin_vec";
  inherit version;

  src = fetchFromGitHub {
    repo = "nu_plugin_vec";
    owner = "PhotonBursted";
    rev = "v${version}";
    hash = "sha256-Trkg46t2xaIr0Z45XFiQ+RqA3Emt9gWRCVZ3JJG/7lM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-gdutANASt2QEaVmuqpRjzuhOT3sTFJb9fK2BXkUMKaM=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];
  cargoPatches = [ lock-diff ];
  patches = [ toml-diff ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A nushell plugin that adds support for vector operations";
    longDescription = ''
      NOTE: This package has been patched for the current version of nushell (0.104.0).
      The author of this plugin does not have a version for this particular version of nushell.
    '';
    mainProgram = "nu_plugin_vec";
    homepage = "https://github.com/PhotonBursted/nu_plugin_vec";
    license = licenses.mit;
    # maintainers = with maintainers; [ aldenparker ];
    platforms = platforms.all;
  };
}
