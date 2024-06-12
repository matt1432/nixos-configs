pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:06dea3ef2e60d055cebea101c3e64a924d822736e9a91e804599e1f8eaaebdf7";
  sha256 = "1w38y23kmdvqj06s0yzwz0c5nrjy0jspnk0n1p6nc71v4a74v101";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
