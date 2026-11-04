pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/niko1221/strata";
  imageDigest = "sha256:83e37db8625c67b61c579fd7c0f9068f2d831037a937f139c569502b54290998";
  hash = "sha256-+nrLrUGIE+Mw8cwUcobH2FSzCBWNe2a2t9F9fCqtFJo=";
  finalImageName = imageName;
  finalImageTag = "0.2.9-cuda13";
}
