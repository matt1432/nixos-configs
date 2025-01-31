{
  buildLua,
  makeFontsConf,
  mkVersion,
  modernz-src,
  ...
}:
buildLua (finalAttrs: {
  pname = "modernz";
  version = mkVersion modernz-src;

  src = modernz-src;

  # Make font available to script
  postInstall = ''
    mkdir -p $out/share/fonts
    cp -r ./fluent-system-icons.ttf $out/share/fonts
  '';

  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = ["${finalAttrs.finalPackage}/share/fonts"];
    }))
  ];
})
