pkgs:
pkgs.dockerTools.pullImage {
  imageName = "weejewel/wg-easy";
  imageDigest = "sha256:ea65f283dfeb62628ce942ce38974f9db05177aa27ab69b787115b78591552f3";
  sha256 = "1cv9s2pgqxqwp7lq2jzf8l58jn9cdhl3gkql6xjf0v5xgj0wifw1";
  finalImageName = "weejewel/wg-easy";
  finalImageTag = "latest";
}
