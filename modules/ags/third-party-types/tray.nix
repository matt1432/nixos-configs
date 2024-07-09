{
  astalTray,
  atk,
  buildNpmPackage,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  harfbuzz,
  libdbusmenu-gtk3,
  pango,
  ...
}:
buildNpmPackage {
  pname = "astal-tray-types";
  inherit (astalTray) version;

  npmDepsHash = import ./npmDepsHash.nix;

  src = ./.;
  dontNpmBuild = true;

  installPhase = ''
    npx @ts-for-gir/cli generate ${builtins.concatStringsSep " " [
      "-g ${astalTray.dev}/share/gir-1.0"
      "-g ${atk.dev}/share/gir-1.0"
      "-g ${gdk-pixbuf.dev}/share/gir-1.0"
      "-g ${glib.dev}/share/gir-1.0"
      "-g ${gobject-introspection.dev}/share/gir-1.0"
      "-g ${gtk3.dev}/share/gir-1.0"
      "-g ${harfbuzz.dev}/share/gir-1.0"
      "-g ${libdbusmenu-gtk3}/share/gir-1.0"
      "-g ${pango.dev}/share/gir-1.0"
      "--ignoreVersionConflicts"
    ]} -e gjs -o ./types

    mkdir -p $out
    cp ./types/astaltray* $out/

    substituteInPlace $out/astaltray* --replace-warn \
      "from '." "from '@girs"
  '';
}
