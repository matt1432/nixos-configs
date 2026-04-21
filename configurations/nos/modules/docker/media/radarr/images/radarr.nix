pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:b01097ad2d948c9f5eca39eb60bb529e2e55b0738c4bf7db09383bef0abab59d";
  hash = "sha256-q56TOJ6TrSkNm0gCY+UrUGTEctyNThsR/zqQA4q/kBY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
