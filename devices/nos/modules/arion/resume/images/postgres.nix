pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:6c2118c2e7c6ad2f627f626bd18fc9b5b7b417f680a7a77a81ded84b6aeff154";
  sha256 = "037s8d7aii3qcz5q33300h00mv2ia824d8xnblc7y5147n8f7axz";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
