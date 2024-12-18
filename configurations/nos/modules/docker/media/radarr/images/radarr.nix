pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:ee4c2213b769bc9a891b5dd5aa1786804634fb681dd261b3bed6b65d98592c55";
  hash = "sha256-Y5K0N6gH0tDtCCZvkhHK2btWWYujOvHZyOTJCDtJRzQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
