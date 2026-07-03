pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:047222423d6d8556a88581b189175bec57f286f120b52ba29c0390fe6babaa5a";
  hash = "sha256-q0aU0pV6kB7Swz7mNitwnXgmPxrtKxVvjkmrVnIYK2E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
