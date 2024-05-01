pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:10761af14a6145353169042f29d2e49943de75b57a5d19251b365fe0d41ee15a";
  sha256 = "01mf31w6wmx2dhdwyjxs5iqw10bl70gdwd69wv3klzm2hhxbx388";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.103.1";
}
