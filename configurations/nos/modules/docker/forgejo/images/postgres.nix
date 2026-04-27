pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:bbb8851608e3ff4901156bf6a4bf90735a9d44ae014c03811bfdb2f9c354b18b";
  hash = "sha256-zPOqy9EQ8yV+kXwQ4WprzFrBscXc66GIOzHIbbu+sWo=";
  finalImageName = imageName;
  finalImageTag = "14";
}
