pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:d80460b3f1d71171d720bd5bcb2e572ad5c7a532b5ae9fe8aec6a44e4cd2a4d5";
  hash = "sha256-ZduOulkm24PDyLIuAO77hWTP9/s2qZommGrWZkF1SbU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
