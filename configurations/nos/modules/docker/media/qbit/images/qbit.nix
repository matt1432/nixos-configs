pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:b024436f8ca665d16d9a997d26fd27fdf867ee5566ba09f32764e7b2976d3e02";
  hash = "sha256-1WAQ/WfY9AO+gq7UiwsjE6eCCsePA9EKbHoDmUcOJ/c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
