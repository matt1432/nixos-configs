pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a02db8cac496f15b094798a38254f14d6e00741f709360e5e00bb6668ea31636";
  hash = "sha256-IPMO8ywiLVd9xP5QGmUWvno62YAmPuZpWzN2a8e14Gs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
