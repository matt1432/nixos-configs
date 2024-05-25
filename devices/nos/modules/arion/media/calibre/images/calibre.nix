pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:7231defed20430b259d5fe3d4905978f9e8c3feb8f318f045d37501c3d847479";
  sha256 = "1bllmbzggwphdc65c5vbijqcn6k23cvd7j9sc0brji2lsrmh9cwr";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
