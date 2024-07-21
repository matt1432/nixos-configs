pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:79f5d0c375b0df84e4d0ac89103753d6145ec3facb329e860008f2813f647d84";
  sha256 = "0mm5wnp21z7lahg3mw5v86b7lv45rkmbh7dwmpikskr94y1m00hs";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.109.2";
}
