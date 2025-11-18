pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:df09693fb40d9ec40c7dec49e29c4f06ee6cbfcba20ef749a5c254ecfc2e99ae";
  hash = "sha256-w/rv44iprtN+gVFzG4JI9u6NWqaj+W5uFd3n2Sz/dnU=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
