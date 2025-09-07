pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:9ac0d53c6f940d0b18481267a3b4b6a6778a13b4bdf4456ffc58f0379b3c0ff7";
  hash = "sha256-YLpcEN5K0CCCjWRpjPrj0ae+Fts+VyDBbSr/g0uggR8=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
