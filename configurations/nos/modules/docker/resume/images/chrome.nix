pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:76bd3c1df1777df5c90fad1c8182395563a45b57105dfe7a22143c24c7b6a300";
  hash = "sha256-+Z6jHetK5Q6SOIFCfZi6wpxmPyMty9277EFs80KStLg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
