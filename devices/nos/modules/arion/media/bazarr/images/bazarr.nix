pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:86ad012fc31e974dcf0147900a202443d92d12f4334a9e4ec89baa2052fb12fa";
  sha256 = "0077wr063dfgd1s8a58ck1srm98j653b11qcihjlm2nj9y53787p";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
