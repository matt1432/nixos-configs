pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:1cf40186b1bc35bec87f4e4892d5d8c06086da331010be03e3459a86869c5e74";
  hash = "sha256-vIhFdVZa55r3GNsoGwgpVG0kT7xjuvyjf+K1n3HW83c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
