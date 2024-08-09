pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c80a2dcfefd85c62da2373c5bf0138bb9d1c647c4b3d8f994ce263f5e8b1db81";
  sha256 = "1yyjjh53n9a1n2czy1a3l9diak960dxf0wy185khhdjyg26grl2m";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
