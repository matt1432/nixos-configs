pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:838757ea055071269e12bb8a4fb43109fb7dbe2340fffd96cb07ecf26b939e25";
  hash = "sha256-Lz5KECwWyYNMTboxP7cFugx0Gqj8e9FkhWAVM21pfuI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
