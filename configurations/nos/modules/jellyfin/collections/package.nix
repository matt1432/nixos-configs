{
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3Packages,
  ...
}: let
  pname = "jellyfin-auto-collections";
  version = "0.0.0";

  interpreter =
    (python3Packages.python.withPackages (ps:
      with ps; [
        apscheduler
        beautifulsoup4
        certifi
        charset-normalizer
        contourpy
        cycler
        fonttools
        idna
        kiwisolver
        loguru
        pluginlib
        pyaml-env
        pytz
        pyyaml
        requests
        requests-cache
        setuptools
        six
        soupsieve
        tzlocal
        urllib3
        url-normalize
        numpy
        packaging
        pillow
        pyparsing
        python-dateutil
        attrs
        cattrs
        platformdirs
      ])).interpreter;
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "ghomasHudson";
      repo = "Jellyfin-Auto-Collections";
      rev = "5976716bc5fb69d9d81e1f6050f60901ebd6c930";
      hash = "sha256-4dfpOgZ6mCbyzFKeP53ZQpfjK1dOp45rsclQzoQjzeQ=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share $out/share/Jellyfin-Auto-Collections
      cp -R . $out/share/Jellyfin-Auto-Collections

      makeWrapper ${interpreter} $out/bin/${pname} \
        --add-flags "-u $out/share/Jellyfin-Auto-Collections/main.py" \
        --prefix PYTHONPATH : "$out/share/Jellyfin-Auto-Collections"

      runHook postInstall
    '';

    meta = {
      mainProgram = pname;
    };
  }
