pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:6e901cc2a12f9ec96fab0162a7d8a4dcbf9353f2357470ef59ebb48bc005ce82";
  hash = "sha256-Z+/TF1QQyru0E+tXa4V4dPntO0yHZlRdeSWvckkhmbk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
