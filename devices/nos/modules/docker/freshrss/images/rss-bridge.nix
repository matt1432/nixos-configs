pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f5b63c60dad245b24912886f6ad20503281a4f8aae4cb886a3797f778fad4ffa";
  sha256 = "09sinziqi3v4aax4yv8j36qc98w93m0mxvmqqgszzd4ziscl5jd9";
  finalImageName = imageName;
  finalImageTag = "latest";
}
