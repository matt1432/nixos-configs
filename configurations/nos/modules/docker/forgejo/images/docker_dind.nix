pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:fbbc96e0af32cdc190aff92ba97a1281a115351a723afe21af78879cc55126b0";
  hash = "sha256-dmS0hwfp3mu2SDRO1dOYioe2AkhPCo8mWAnxArLK5nA=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
