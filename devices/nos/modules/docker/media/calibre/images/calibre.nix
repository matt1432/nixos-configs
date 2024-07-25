pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:9d769fe402690da7f3ca750a925859ef99b4e5bec86d4739f87c7cd43e18a246";
  sha256 = "1bqhv4g05q0cn16as86w55gawzaxjb8yipj21vwvj95xapp75fib";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
