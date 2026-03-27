pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:1ea245ba4cd7082dcf5df9af60883e86588fa714ad2bdfde9717badf24b8ac2d";
  hash = "sha256-YXwkMH5OMDUcN9/09Abw+cllB/oiRotvZCa85dtzQW8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
