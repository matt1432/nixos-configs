{
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  name = "dracula-bat";

  src = fetchFromGitHub {
    owner = "matt1432";
    repo = "bat";
    rev = "270bce892537311ac92494a2a7663e3ecf772092";
    hash = "sha256-UyZ3WFfrEEBjtdb//5waVItmjKorkOiNGtu9eeB3lOw=";
  };

  installPhase = ''
    mkdir -p $out/bat
    cp -a ./Dracula.tmTheme $out/bat
  '';
}
