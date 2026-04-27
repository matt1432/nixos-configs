pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:b8eeeccabcf0e33f09ae8a61f8e432f0837898e6542a118437cf482739d986ff";
  hash = "sha256-xSTowOVqO5Vfgry+QBlr+9HEd1pZboxRMgj3WwIq1ZU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
