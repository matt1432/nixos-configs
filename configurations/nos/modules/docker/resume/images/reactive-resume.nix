pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:bfacee69faad04a8b785854d02cb078fb223824e8b07a07ff21fa39ebfa9fe8c";
  hash = "sha256-dBIeS3qbLnN+WbmwNwcFVFULAS5s60+Czimep/cynAY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
