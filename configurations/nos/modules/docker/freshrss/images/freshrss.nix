pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:af44385229541bee24aa9148d0ff8f3b40e095373c63a2c0f74e09a27d3c59df";
  hash = "sha256-QKwaHtW8WYsCm3RPPkya0xiqfCsrtf8XmavgMiS6AIw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
