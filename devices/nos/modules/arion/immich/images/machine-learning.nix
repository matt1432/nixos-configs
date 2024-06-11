pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:3aecde307deb0c881a1b4cbaf51db965e5ba1c085b8b4abb1a88c0225812cb05";
  sha256 = "1zwmzl5cd73zja039q9g3f57dmpdzsavl6im9s3m0g46pwnk44nz";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.106.2";
}
