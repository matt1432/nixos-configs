pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:9600eff5a66ae426293f00b171711bc1647c85cf966d759ee08ab2d05e0580b5";
  sha256 = "1m189s6i8hii4vrsjx3ypa5p2brz8sa3fw5jyxhh6qm42r4xnp4c";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.112.1";
}
