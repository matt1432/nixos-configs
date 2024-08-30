pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:7b1d8f14c3905469c4f20488e78082dc6ca8a50b61798cc38f669a63f897f6b5";
  sha256 = "1giblysl8amn844p4dsvfcq82p42lf8cg53v4fkdq4nx7m109751";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
