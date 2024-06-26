{
  buildLua,
  makeFontsConf,
  mkVersion,
  modernx-src,
  ...
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = mkVersion modernx-src;

  src = modernx-src;

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
