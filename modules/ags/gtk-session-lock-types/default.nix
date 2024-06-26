{
  atk,
  buildNpmPackage,
  gdk-pixbuf,
  gobject-introspection,
  gtk3,
  gtkSessionLock,
  harfbuzz,
  pango,
  ...
}:
buildNpmPackage {
  pname = "gtk-session-lock-types";
  version = "0.0";

  npmDepsHash = "sha256-HtQUmDnq0344Ef8W8jW8idSYGj02q/DB4p/gpmWL3iA=";

  src = ./.;
  dontNpmBuild = true;

  installPhase = ''
    npx @ts-for-gir/cli generate ${builtins.concatStringsSep " " [
      "-g ${gtkSessionLock.dev}/share/gir-1.0"
      "-g ${gobject-introspection.dev}/share/gir-1.0"
      "-g ${gtk3.dev}/share/gir-1.0"
      "-g ${pango.dev}/share/gir-1.0"
      "-g ${gdk-pixbuf.dev}/share/gir-1.0"
      "-g ${harfbuzz.dev}/share/gir-1.0"
      "-g ${atk.dev}/share/gir-1.0"
    ]} -e gjs -o ./types

    mkdir -p $out
    cp ./types/gtksessionlock* $out/

    substituteInPlace $out/gtksessionlock* --replace-warn \
      "from '." "from '@girs"
  '';
}
