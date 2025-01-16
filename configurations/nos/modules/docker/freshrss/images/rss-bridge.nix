pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:6b18e6d0760571accded516a2599f0f00412a480f10e8a8a23d9bcfae591e645";
  hash = "sha256-K7ZfpNV9Cn4XGhxo/a+Fp+rBfeijTMZiheS75jDlwJM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
