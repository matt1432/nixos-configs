pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:78a275d4c891f7b3a33d3f1a78eda9f1d744954d9e20122bfdc97cdda25cddaf";
  hash = "sha256-0cShBpvsoDyE5NmkPX5svlYTYVWVy0rrjwKLn0qYovY=";
  finalImageName = imageName;
  finalImageTag = "15.2";
}
