pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:c07f5319d20bdbd58a19d7d779a1e97159ce25cb95572baa947c70f58589937c";
  sha256 = "0a3k5b0718ykakl10jjlyvg7mf72xhmy5izdgidd5sj5lbzm1af6";
  finalImageName = imageName;
  finalImageTag = "latest";
}
