pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:7fe57565907f4f776d43c15b2e020a0e4a62fe1e04e80e25b85a3ae4ca49e5d0";
  sha256 = "0mcsjkzjjyn53zv3id7jdkk0x1w5h6hz1sp2cpizsh444cznr2gd";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
