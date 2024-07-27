pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:4faf2f19c7a2be559354821e7da57477c236a22afb78e17a40dd40a75a120435";
  sha256 = "0gz98hwn73gw347h6i1y6rnwz6i8ng2zs65xabzsfsfpcr5fwv2l";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
