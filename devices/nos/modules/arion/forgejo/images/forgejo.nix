pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:d036b8021aac6449e3a128fda50bae3598f1403578f3e83bb7717bceb60ae875";
  sha256 = "0qs8hvpkpjy9hc3kjkqpb462h8s73d49ac6r7mdhgrljkb7m29qg";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.11-1";
}
