pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:2860af6a7fa5521b2cdb26a14545c083ffd06b2528dbfc470cfec39a0b6bde39";
  hash = "sha256-Kqf3dwSIvq/Ek6XgYADTadL8mP/6JQDNsxhN2JLDfL8=";
  finalImageName = imageName;
  finalImageTag = "12";
}
