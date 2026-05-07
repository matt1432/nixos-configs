pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:3d49075f9115054ae2485d8cea2819296a904dfd4f00017285168028615d8533";
  hash = "sha256-36R/rN1mYEfKWGHYiNDgxnngb4QG3gTfzy1eBuxRvFM=";
  finalImageName = imageName;
  finalImageTag = "12";
}
