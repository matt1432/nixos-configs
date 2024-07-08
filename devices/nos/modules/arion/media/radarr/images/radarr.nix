pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:bf5aaf1577edbc3ba33db069676e7f8324eda33761ca59721942bc8ef56c015c";
  sha256 = "08kdrxrvalvrb2g37fsn7zmhshfyc5n0k4h41wbdbyihs87ddvqr";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
