pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "amruthpillai/reactive-resume";
  imageDigest = "sha256:da0bb7109bc3066a64c97d03d6e1f61c31eb51ae3d1c1ddefa6764c861680fd8";
  hash = "sha256-2X/iRjYm//kp5cMDntJMEmLS93wb5LGElgAUQxnU7ts=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
