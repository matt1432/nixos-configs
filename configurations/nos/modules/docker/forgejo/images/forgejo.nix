pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:2fdfe28b5c68f82f49580e227b84e2afb43af0250e0631a54a386ef3b1d9b759";
  hash = "sha256-kulPQ8rL0o51ihCpsvTZPVmyMGqmDTie77D9AKnnsuY=";
  finalImageName = imageName;
  finalImageTag = "16";
}
