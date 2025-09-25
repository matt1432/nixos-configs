pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:e424330f048ff1401f22413e34ee11c25ac2de79b6213c6ead3f593b44626c55";
  hash = "sha256-iOj5rCkKNJFL73KKJmPVVB1JSDMF2EF5zauYxJYpRfk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
