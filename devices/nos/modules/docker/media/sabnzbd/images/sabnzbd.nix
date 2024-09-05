pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:66576a72ecb80c8d9e8ebffd4699995b29bfff4aefba4c6eae14baac3cbf6716";
  sha256 = "10g4i9shbwgd9dswf5gx3jvnjcks0bn5mmadr39h8rfw3h31sq1v";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
