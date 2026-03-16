pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:343deeeb05b3c844026bbd6f37fbcb41dac64e9185a0f0eecc199748ad724a4f";
  hash = "sha256-DeWD907qCAaO9FnDAc6L4pF+2F9KuvAPfBeXr8FC21E=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
