pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:823196c45d0cdbf70e5782e1b6cc116b3417211ce1884c373afff97abec7be2f";
  sha256 = "01zybz808fxx1k74qji09ni5kpw7bmg95kglfm1cx1294jq1vv7d";
  finalImageName = imageName;
  finalImageTag = "14";
}
