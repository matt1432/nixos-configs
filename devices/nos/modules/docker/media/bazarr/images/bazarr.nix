pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:7391c8c31a190aa676ca3596b54c243e731411cb8bdfef50f94f3e5c559520b8";
  sha256 = "0jswwq8lsy10fnpjir7vf84yq46997djpdc7hxxf2lq7w9wk3za7";
  finalImageName = imageName;
  finalImageTag = "latest";
}
