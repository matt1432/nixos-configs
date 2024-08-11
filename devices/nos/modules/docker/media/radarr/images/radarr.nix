pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:71e29caebf16da4701fc7a6c04d5f34c6b01753549900edf4ecfa585263ea1d4";
  sha256 = "0i597qpq45rcm2ciy8mc5fyfr4d5wyrsdwxcbr96xc6xxiqrvs22";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
