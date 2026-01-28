pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:6c011eaa315b871f3207d68f97205d92b3e600104466a75b01eb2c3868e72ca1";
  hash = "sha256-shZnMNtjpRgh35UFUCYnJId4XcccIH27E/yJEe81+Oo=";
  finalImageName = imageName;
  finalImageTag = "release";
}
