pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c092cf279e27359775a11dc9ce6cf2cf22975a36105c4f6214fa9df60cf0a1c4";
  sha256 = "0b9vjxrk8xwpab3g4dkrkc667g4d561m2s6hxx4yvb3gh9vnincd";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
