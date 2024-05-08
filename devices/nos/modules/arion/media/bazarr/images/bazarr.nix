pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:081575bb4b4936b3dd9fce9bd5bcb7a9140e9b072bada4115b45b0db11daa913";
  sha256 = "0b80g9g0hlhxz1dv5jm71rik5c95xqm5bnpvbagjv68q0ryi04xz";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
