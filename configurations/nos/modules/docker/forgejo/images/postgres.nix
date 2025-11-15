pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:fd8261236f7ecebba5ed807655dd91379901cc810e219758d4c66757565694f0";
  hash = "sha256-aO6DM8HoHySV/KmsLm05YSC1w/z/VZ6X2be+qSM7NLU=";
  finalImageName = imageName;
  finalImageTag = "14";
}
