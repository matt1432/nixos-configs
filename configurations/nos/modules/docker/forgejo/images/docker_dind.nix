pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:5efed980cba3fc126cf54e21a5a6ff8849d05b6e0623d6e7612f48e9cd6cd17e";
  hash = "sha256-yD0sgUWDsgfDs7dQom2EdDENR8HCc+JmL7Lqd8TiIs8=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
