pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:33f2b0899aae5327d03c60d25714d4c76e1ff9879ef64552641cb9b3035c3878";
  sha256 = "1qdy3rfq1kmh24ph8zln6kqf5chd957nnf6mrmb5h7kdcxvacz0d";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.4-fpm";
}
