pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:f1b771bf5f911ddb11aa86170ae27fab5ccde7d4671edcde6a3b264af8662945";
  sha256 = "0i8cnk0x5ar28nfmp7sgqzs3fm9fvdhv2g9ik5iw0sgxqs2znccs";
  finalImageName = imageName;
  finalImageTag = "latest";
}
