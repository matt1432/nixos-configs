pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:456898884eb289ef4590e654804e05b84866279495768bf12bc91451ca160329";
  sha256 = "1pgcd1lk9x93q16l732yfd7dz3ywc0yjrdyfxj5p5y5x9ni30dpz";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
