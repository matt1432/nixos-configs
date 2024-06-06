pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:0e8708498272dac567b9d1654822ccb22037cf4b1792ec75b9929e70e53ddd16";
  sha256 = "0qff5bvr21ibli4pxd6cs0knfmyh25s5123z9d1lndrlvnvifbdx";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
