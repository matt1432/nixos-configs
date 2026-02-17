pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:6d3e68474ea146f995af98d3fb2cb1a14e2e4457ddaf035aa5426889e2f9249c";
  hash = "sha256-7jHSXTzXha9ODbNsnZGyOweuArVB8GFrFtlbFgSG8DQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
