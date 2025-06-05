pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:9b2bd607298f7968b57a9765a115f4011f77824b9c7fc10d380272bc445fb7fa";
  hash = "sha256-CyODbP+Igyw3qlkY3dIsXnrVoB3pVNA6+4/zN2gDd/s=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
