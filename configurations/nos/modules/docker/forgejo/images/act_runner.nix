pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:8e415c329f6351ab32b7bd12f30316e0f6c877bd97fef5bc3a86598335e424c5";
  hash = "sha256-UNMfe+2MEYTcRHhB0hLyC8UMy6uQuMFlTHyWAQjd4/I=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
