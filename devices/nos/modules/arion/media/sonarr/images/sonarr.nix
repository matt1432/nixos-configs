pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:8414846e440ca34c1cbed96daf7d5b3bcde20aab79761aaaaef496f24cec8d20";
  sha256 = "02p0zjkcxcm091qdja465kibqp49q79ysrnxpbn0dh0zaff5i4bm";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
