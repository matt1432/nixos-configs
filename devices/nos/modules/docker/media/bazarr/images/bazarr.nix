pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:0d544276b51e11fb96f4bccd7d5babef597be0199364a11c0cdf24ab0470c381";
  sha256 = "1x5v9rqzrhwdqvjakq9190ji15gqwk6hjx64m14dfgvp03lah44l";
  finalImageName = imageName;
  finalImageTag = "latest";
}
