pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8b963ea3038c3b32182ee7f592ccde21242fa7c5fd9d1b72aa333c27f1bfc809";
  sha256 = "0cfmp4v1a4b2m21ljsc3f3kn23rl9nki6z37ks9jclzxh9hy629n";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
