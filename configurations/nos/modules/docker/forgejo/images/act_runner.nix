pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:613a03709abbf5642057d6e26c043bead207cf9af89a716652a589255ced221b";
  hash = "sha256-OtANC+E7lHGK0zyEly69GgDpuGk7BhFKwThvJTywq9U=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
