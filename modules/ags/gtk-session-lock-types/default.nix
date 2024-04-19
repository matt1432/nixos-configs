{
  gtk-lock,
  buildNpmPackage,
  ...
}:
buildNpmPackage {
  pname = "gtk-session-lock-types";
  version = "0.0";

  npmDepsHash = "sha256-HtQUmDnq0344Ef8W8jW8idSYGj02q/DB4p/gpmWL3iA=";

  src = ./.;
  dontNpmBuild = true;

  installPhase = ''
    npx @ts-for-gir/cli generate -g '${gtk-lock.dev}/share/gir-1.0' -o $out
  '';
}
