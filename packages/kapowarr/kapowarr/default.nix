{
  # nix build inputs
  lib,
  stdenv,
  python,
  makeWrapper,
  Kapowarr-src,
  # deps
  rar,
  # python deps
  aiohttp,
  beautifulsoup4,
  bencoding, # from overrides
  cryptography,
  flask,
  flask-socketio,
  requests,
  typing-extensions, # from overrides
  waitress,
  websocket-client,
  ...
}: let
  inherit (lib) getExe;
  inherit (builtins) fromTOML readFile;

  pyproject = fromTOML (readFile "${Kapowarr-src}/pyproject.toml");

  dependencies = [
    typing-extensions
    requests
    beautifulsoup4
    flask
    waitress
    cryptography
    bencoding
    aiohttp
    flask-socketio
    websocket-client
  ];

  pythonExe = getExe (python.withPackages (ps: dependencies));

  pname = "kapowarr";
  version = "${pyproject.project.version}+${Kapowarr-src.shortRev or "dirty"}";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = Kapowarr-src;

    nativeBuildInputs = [makeWrapper];

    postPatch = ''
      # Remove shebang
      sed -i 1d ./Kapowarr.py

      # Disable PWA for now
      substituteInPlace ./backend/internals/settings.py \
          --replace-fail "with open(filename, 'w') as f:" "" \
          --replace-fail "dump(manifest, f, indent=4)" ""

      # TODO: makes sure this works
      substituteInPlace ./backend/implementations/converters.py \
          --replace-fail \
              "exe = folder_path('backend', 'lib', Constants.RAR_EXECUTABLES[platform])" \
              "exe = '${getExe rar}'"
    '';

    buildPhase = ''
      mkdir -p $out/${python.sitePackages}
      cp -r ./. $out/${python.sitePackages}
    '';

    installPhase = ''
      makeWrapper ${pythonExe} $out/bin/kapowarr \
          --add-flags "$out/${python.sitePackages}/Kapowarr.py"
    '';

    meta = {
      inherit (rar.meta) platforms;
      mainProgram = pname;
      license = lib.licenses.gpl3Only;
      homepage = "https://casvt.github.io/Kapowarr";
      description = ''
        Kapowarr is a software to build and manage a comic book library,
        fitting in the *arr suite of software.
      '';
    };
  }
