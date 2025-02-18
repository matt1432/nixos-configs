{
  # nix build inputs
  lib,
  buildLua,
  mkVersion,
  makeFontsConf,
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

  meta = {
    license = lib.licenses.lgpl21;
    homepage = "https://github.com/Samillion/ModernZ";
    description = ''
      A sleek and modern OSC for mpv designed to enhance functionality
      by adding more features, all while preserving the core standards
      of mpv's OSC.
    '';
  };
})
