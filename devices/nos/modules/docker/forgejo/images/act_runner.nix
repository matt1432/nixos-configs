pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:06ab3f910c5015792942d8c338fd865d3dff1163cea2e8c3efd32330c7775802";
  sha256 = "1rvn2wgv54dlrw3g6hzzri543s668f2j6ppkys7g33pdbk435yvh";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
