pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:d6820874de49c972e7a3421fa53776bef18d4a41b78af931fd50827298ee913c";
  sha256 = "0ahldmavinqn910riplq8vkgl4qj0xp91n073f0kkfjqf5lmaywp";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.97.0";
}
