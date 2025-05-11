pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:105b7ffb9e88880a55a3fcd6116542f19af21aae8884a4e276e007d2816bbacb";
  hash = "sha256-QGt0p5at2bWwC7bSDfsvg1mhmtu4H3fK834DXo6/U/Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
