pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:962ffbe9f6418387643411b127c1db27465e5a23b9a8849bfaf45fa6323963ce";
  hash = "sha256-QB5wMFo4jPxnQ4Wb+dBGStcobEwMNM9oRC0LErBdFP0=";
  finalImageName = imageName;
  finalImageTag = "14";
}
