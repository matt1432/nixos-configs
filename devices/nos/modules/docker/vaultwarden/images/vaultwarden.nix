pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:7271b8ceb729f9b46144c800125813dcc8d16bb6874217c48e59b22b45e47d7d";
  sha256 = "11770g5g821i6wblydjdy1mp2j5w1w0ajnz762ivhlfbwyvs1yzv";
  finalImageName = imageName;
  finalImageTag = "latest";
}
