pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:d04371d3a649d27f84d6faaa8a8cecbdc1b833ebb6466383816935b8e9c6ed2a";
  hash = "sha256-LdCFqoRnchMJ9izIf2/0KXNvlaoBG1qFzHpTEDca/+4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
