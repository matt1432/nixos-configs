pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c93f075dc5afb74dc7a0a55e90974f81425a5d3c5d293022c5416431f4963ce9";
  sha256 = "05wlrw597wrhglqzcki4fsqq4zm7wlyw5hzsm7jdq4dibji819x5";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
