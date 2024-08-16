final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=334866
  rubber = prev.python3Packages.buildPythonApplication rec {
    pname = "rubber";
    version = "1.6.6";
    pyproject = true;

    src = prev.fetchFromGitLab {
      owner = "latex-rubber";
      repo = "rubber";
      rev = version;
      hash = "sha256-C26PN3jyV6qwSjgPem54bykZrpKj+n8iHYYUyR+8dgI=";
    };

    postPatch = ''
      sed -i -e '/texi2dvi/d' hatch_build.py

      substituteInPlace tests/run.sh \
        --replace-fail /var/tmp /tmp
    '';

    nativeBuildInputs = [prev.python3Packages.hatchling prev.texinfo];

    checkPhase = ''
      runHook preCheck

      pushd tests >/dev/null
      ${prev.stdenv.shell} run.sh
      popd >/dev/null

      runHook postCheck
    '';
    meta.mainProgram = "rubber";
  };

  # FIXME: https://pr-tracker.nelim.org/?pr=334814
  delta = prev.rustPlatform.buildRustPackage rec {
    pname = "delta";
    version = "0.17.0-unstable-2024-08-12";

    src = prev.fetchFromGitHub {
      owner = "dandavison";
      repo = pname;
      rev = "a01141b72001f4c630d77cf5274267d7638851e4";
      hash = "sha256-My51pQw5a2Y2VTu39MmnjGfmCavg8pFqOmOntUildS0=";
    };

    cargoHash = "sha256-Rlc3Bc6Jh89KLLEWBWQB5GjoeIuHnwIVZN/MVFMjY24=";

    nativeBuildInputs = with prev; [
      installShellFiles
      pkg-config
    ];

    buildInputs = with prev;
      [
        oniguruma
      ]
      ++ lib.optionals stdenv.isDarwin [
        darwin.apple_sdk_11_0.frameworks.Foundation
      ];

    nativeCheckInputs = [prev.git];

    env.RUSTONIG_SYSTEM_LIBONIG = true;

    postInstall = ''
      installShellCompletion --cmd delta \
        etc/completion/completion.{bash,fish,zsh}
    '';

    # test_env_parsing_with_pager_set_to_bat sets environment variables,
    # which can be flaky with multiple threads:
    # https://github.com/dandavison/delta/issues/1660
    dontUseCargoParallelTests = true;

    checkFlags = with prev;
      lib.optionals stdenv.isDarwin [
        "--skip=test_diff_same_non_empty_file"
      ];

    meta.mainProgram = "delta";
  };
}
