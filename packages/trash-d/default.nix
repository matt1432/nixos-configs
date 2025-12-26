{
  # nix build inputs
  lib,
  buildDubPackage,
  fetchFromGitHub,
  # deps
  scdoc,
  ...
}: let
  pname = "trash";
  version = "21";
in
  buildDubPackage {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "rushsteve1";
      repo = "trash-d";
      rev = version;
      hash = "sha256-/spFB2/LUbf/uWAZQ88Y5HIPLCPmN/KJpyUTvzICyHM=";
    };

    dubLock.dependencies = {};

    nativeBuildInputs = [
      scdoc
    ];

    postPatch = ''
      substituteInPlace ./dub.json --replace-fail '"dflags-linux-ldc": ["-static"],' ""
    '';

    installPhase = ''
      runHook preInstall

      scdoc < MANUAL.scd > build/trash.1

      mkdir -p $out/{bin,man/man1}

      cp -a ./build/trash $out/bin
      cp -a ./build/trash.1 $out/man/man1

      runHook postInstall
    '';

    meta = {
      mainProgram = "trash";
      license = with lib.licenses; [mit];
      platforms = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
      ];
      homepage = "https://github.com/rushsteve1/trash-d";
      description = ''
        A near drop-in replacement for `rm` that uses the
        [FreeDesktop trash bin](https://specifications.freedesktop.org/trash-spec/trashspec-latest.html).
      '';
    };
  }
