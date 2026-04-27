pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c5de2a8758a05594319263e7691c1dce56899442ed1720d6eca216c0958f4caf";
  hash = "sha256-GQQz8AWF4z7ticTwooobmuw+rbDnugoGWg8fpZOmn8g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
