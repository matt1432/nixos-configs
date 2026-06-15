pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:698a43664d4525dc8fff1ff0ecd3153c526f52bc4e1616a91fa737c7854a7966";
  hash = "sha256-uWVCvqg/jFHdaTeG56foYRPkuy+E6olgH2TOM1WTRmE=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
