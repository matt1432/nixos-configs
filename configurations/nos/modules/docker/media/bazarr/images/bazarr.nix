pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:4b5e510042bf471c8bafab89cada9774fba2fb25f16ec64235151cacbe847c10";
  hash = "sha256-C/eaAm83okwTtYoHOFsP9ja/DugdY1+TwvJ8lQbq/Gw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
