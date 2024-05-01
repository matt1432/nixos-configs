pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:2c9269dd25c62d46e679a035849f32e963152ec44000e30f008d211a2f70e80c";
  sha256 = "14ljv9jcczhdd5pzdyvmf6zs57bikhrbqi6vwpgjdg5dyka3ikc5";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
