pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:d6f07b454c0ec7e4ba3a5926fff2482f8fd1a9922b489122dec33b11a4f37bdd";
  hash = "sha256-4XMrJQzlWsvnMSyDdZsHUa8I4QPHgYaTmo0OKix3ETw=";
  finalImageName = imageName;
  finalImageTag = "release";
}
