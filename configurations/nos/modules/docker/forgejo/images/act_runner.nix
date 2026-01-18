pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a20abb253cad2e10f54c2944a630fc67318fb8de3c18751af907cdd486a06708";
  hash = "sha256-z6B3CJ9xaSshzOIerE0pgYePujrbiEnm7k9kuiKpsig=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
