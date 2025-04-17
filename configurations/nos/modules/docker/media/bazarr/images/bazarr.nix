pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:b98bdcac54db7ed05524fb63447b855d7fc419428222b3827b1cc9655f95bf51";
  hash = "sha256-NefisUb38Lia+InLyOktZO8anr9PL+yNAgGaz1Vr+ok=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
