pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:6cf2acc4b250afa14253abc2450cce584f766c242e884571c05c10020b327671";
  hash = "sha256-em5pLE/PbKKFMkQOFnCQ4touo0EmD8k91v/RCnrxqPc=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
