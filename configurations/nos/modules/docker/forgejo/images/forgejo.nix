pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:7bb6f1e34a5669f634948ecb613c301bf756de93e8ecc1247d57012d4d649e64";
  hash = "sha256-WPHM0TWSWeuUR2UetarNniCf6qWvprIGO/8sod3xHV8=";
  finalImageName = imageName;
  finalImageTag = "10";
}
