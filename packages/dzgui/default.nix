{
  # nix build inputs
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  # deps
  python313Packages,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  iputils,
  xdg-utils,
  ...
}: let
  pname = "dzgui";
  version = "7.0.0b28";

  src = fetchFromGitHub {
    owner = "aclist";
    repo = "dztui";
    rev = version;
    hash = "sha256-yVvSvkkl1udpxtZD+iVnitkJF1lMtfrE7E2hNNA3iPg=";
    fetchSubmodules = true;
  };

  python-a2s = python313Packages.buildPythonPackage {
    pname = "python-a2s";
    version = "1.4.1";
    format = "setuptools";
    src = "${src}/dzgui/lib/a2s";
  };

  dayzquery = python313Packages.buildPythonPackage {
    pname = "dayzquery";
    version = "1.3.1";
    format = "setuptools";
    src = "${src}/dzgui/lib/dayzquery";
    dependencies = [python-a2s];
  };
in
  python313Packages.buildPythonApplication {
    inherit pname version src;
    format = "pyproject";

    postPatch = ''
      # find_library doesn't work on NixOS, pygobject3 links girepository itself
      substituteInPlace ./dzgui/init/libgi.py \
        --replace-fail 'return bool(find_library("girepository-2.0"))' 'return True'

      # setuptools_scm can't find the data files without .git
      substituteInPlace ./pyproject.toml \
        --replace-fail '"setuptools_scm"' ""

      cat >> ./pyproject.toml <<EOF

      [tool.setuptools.packages.find]
      include = ["dzgui*"]

      [tool.setuptools.package-data]
      dzgui = ["data/*", "data/**/*"]
      EOF
    '';

    build-system = with python313Packages; [setuptools];

    nativeBuildInputs = [
      gobject-introspection
      wrapGAppsHook3
      copyDesktopItems
    ];

    buildInputs = [gtk3];

    pythonRelaxDeps = true;

    dependencies = with python313Packages; [
      dayzquery
      packaging
      psutil
      pygobject3
      python-a2s
      requests
      vdf
    ];

    dontWrapGApps = true;
    preFixup = ''
      makeWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
        --prefix PATH : ${lib.makeBinPath [iputils xdg-utils]}
      )
    '';

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        desktopName = "DZGUI";
        comment = "DayZ server browser and mod manager";
        exec = pname;
        icon = pname;
        categories = ["Game"];
      })
    ];

    postInstall = ''
      install -Dm644 ./dzgui/data/images/icon.png $out/share/pixmaps/dzgui.png
    '';

    pythonImportsCheck = ["dzgui"];

    meta = {
      mainProgram = "dzgui";
      license = with lib.licenses; [gpl3Plus];
      homepage = "https://github.com/aclist/dztui";
      description = ''
        DayZ server browser and mod manager for Linux.
      '';
    };
  }
