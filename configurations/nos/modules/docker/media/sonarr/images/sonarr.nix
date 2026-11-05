pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:386c962ee6e260e3a5656b25df2ed056bcc9b6410e197d075f9547fd14c23bca";
  hash = "sha256-9ihzgxMANdJW4eVKw6C0BSr17JmQYGKOe03f3+TAejE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
