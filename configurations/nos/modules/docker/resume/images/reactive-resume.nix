pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:d3ccfeaf6f65abd56909dbe805d4320e77b8752b40b7aa34d8eec68f71a926c4";
  hash = "sha256-Y8ZPuCMd+fSmTaP9/pwqV7gvYfXbS7n9SVt9h7YXzNs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
