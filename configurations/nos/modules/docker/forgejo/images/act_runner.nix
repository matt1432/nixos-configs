pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:19ed763f9301732d9da4ff072561adcc46971e7f02ccc834f1358791fd7d0d0e";
  hash = "sha256-rqE3Zz48kMVzZw/TQDY5oy4y70KzLAvHPcTVdXa5+Ek=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
