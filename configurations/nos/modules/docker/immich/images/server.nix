pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:9be304ef1c5cb1b7c69ad8db62a9bde41480ac9bb5084bd6263c75dd5792503f";
  hash = "sha256-b4MtUsDevGVIBKCTnEsyY30Ts+ULDqaQsPnEuDz9hRs=";
  finalImageName = imageName;
  finalImageTag = "release";
}
