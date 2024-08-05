pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:e32de15c6f35ba0cabdd728d29f35de4774bc6107ffc34203843237c33a5cf90";
  sha256 = "1l3njzhsaapcs0fbmd1dkgb24ray87i11pbd5x22s2mckcnsladc";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
