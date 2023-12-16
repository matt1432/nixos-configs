{
  fetchFromGitHub,
  makeFontsConf,
  buildLua,
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "cyl0";
    repo = "ModernX";
    rev = "d053ea602d797bdd85d8b2275d7f606be067dc21";
    hash = "sha256-Gpofl529VbmdN7eOThDAsNfNXNkUDDF82Rd+csXGOQg=";
  };

  # Make font available to script
  postInstall = ''
    mkdir -p $out/share/fonts
    cp -r ./Material-Design-Iconic-Font.ttf $out/share/fonts
  '';
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = ["${finalAttrs.finalPackage}/share/fonts"];
    }))
  ];
})
