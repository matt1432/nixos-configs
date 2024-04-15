pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:de7e51182113b430d9b6cb93ebc3389e1c73f11e7eabf47d0af5de106cdc296a";
  sha256 = "10vhh5alacsifsskh2ylgam06h2i695ggav19w1ksa60szmh5wfa";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
