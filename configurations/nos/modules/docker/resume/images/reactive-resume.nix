pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:adaa9e95ea80c91d2a1ddc6cf1d5924268f6f5d610910eae29126b152395aab4";
  hash = "sha256-owDJ9WxYpadGZ/o4zCZwFHiIe4FwdXHScfPIGoYXbSc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
