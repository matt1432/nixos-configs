pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:6b4ce037964e4bf50d341bc9b3aa800238d46ff7de4d7ecc029280c4bb5b2e68";
  sha256 = "1jfr4sqammwc3j0g1b4cr2afgjl7b403kgg33qhl4p2nlafckwjv";
  finalImageName = imageName;
  finalImageTag = "latest";
}
