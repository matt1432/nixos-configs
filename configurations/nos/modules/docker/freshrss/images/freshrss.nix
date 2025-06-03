pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:f9733e2cdf754d82e25826324fb4cbf3d736d82e2d36bf8e379dd4f0eeee0932";
  hash = "sha256-92YmrFgq3ATFa4GTHHTSR//SKccoYo/g4tfA7ZgZOWE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
