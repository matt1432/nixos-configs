pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:3cca923bc8eaa3616c48fc6088005e08d574cf1acf6c1253c92393ae11e4788d";
  sha256 = "0jaxcbawvrcrikgl9xk8fy689j882ibsx9jg01i9xh30nskcn601";
  finalImageName = imageName;
  finalImageTag = "release";
}
