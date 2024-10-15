pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:e0045d420eaf298a9449e12ed1cce654f171cc1043311f0f1cadaf2afeabe795";
  sha256 = "10j6m5fn4r2qngkcw1zmz41lf0ipmkg5gs2mz67bx9jxx6iap27q";
  finalImageName = imageName;
  finalImageTag = "latest";
}
