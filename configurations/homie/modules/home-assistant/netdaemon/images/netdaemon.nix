pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon5";
  imageDigest = "sha256:cfc7a39feee300e77bd6ecc798c15f046b8d222ce251a3c57697069db78841f8";
  hash = "sha256-AzzlLiyM0OOtVSEObAxEn8D8+/RKaND/bwvrfUchiTs=";
  finalImageName = imageName;
  finalImageTag = "25.5.0";
}
