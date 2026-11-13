pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:187e41745c65a2c5e136fbc92137979d6b62d1bf8844f9ebd7681677ad361d63";
  hash = "sha256-yXo7zIEFEWet94gChIByI541qEipvPxM1CRsq3Z8kSs=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
