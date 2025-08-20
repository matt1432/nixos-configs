pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:2b53d2708fc755aab499a96e865be5ae6deeafb99e855e235e8870b4013c56cd";
  hash = "sha256-2FDYhoZLHFT5Tx/V8/chj3f8ZMgzfMdcyURxPgyKuIc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
