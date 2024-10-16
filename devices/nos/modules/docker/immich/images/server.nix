pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:f158810c90f80162f9b08729bbaec963731f12662960be38ff93093b78a0bbdf";
  sha256 = "062vlbjyn214z8knamjk399zv78cibd4bbyvmcmn08d2bk4ra5qv";
  finalImageName = imageName;
  finalImageTag = "release";
}
