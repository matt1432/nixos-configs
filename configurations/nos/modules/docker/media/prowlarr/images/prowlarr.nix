pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:dec1e580aad36bccaeb1aba283f01a5263761905c304875a603c9a952ecfda79";
  hash = "sha256-5uk+46+raFTUY2mFaY13Vs69SS8d3huNuld85q2YTk4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
