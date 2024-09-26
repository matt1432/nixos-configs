pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:baedf173d60b63c72f93fdb8480ee002d4622cd34103aac6510f45fdff41effe";
  sha256 = "1d2mfvl02akq2wadvwqxgjx7ph7gw3d9ps5rcp8v4fyzq21xnmcv";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
