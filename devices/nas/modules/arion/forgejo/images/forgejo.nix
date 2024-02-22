pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:0b61ce92583de5d1bab8e4f6e4774e2138370ae07caf222f3eef44e083021942";
  sha256 = "1f6a88b3d8d7haxxsqhvn1l4g8wc6kbd37q8lfifjyhg0swmscf6";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.6-0";
}
