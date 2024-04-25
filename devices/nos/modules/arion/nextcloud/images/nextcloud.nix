pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:0a4e5f7e271888914cbf1e26b462f8cb44afb42681f404a32dcb47273c1eb446";
  sha256 = "17mafd6ya0fg9h751shmkw4jyil1ix3vkpk87vm6jxxmw97hr8zx";
  finalImageName = "nextcloud";
  finalImageTag = "28.0.4-fpm";
}
