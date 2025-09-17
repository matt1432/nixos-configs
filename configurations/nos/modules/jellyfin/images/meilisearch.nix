pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:38e0ae3cfd2f319461f321c79a1d9320143a2258ee0e2f567bc9441d79dcff5f";
  hash = "sha256-kgrOQRDOxfvpVwuz+atXPNuF/c3q9isvVBcaGu3Zg74=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
