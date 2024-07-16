pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1eaf9e83fca2b9170d4f49f6c0e55ba38693718e7815743a9ec297d199ab1e73";
  sha256 = "1k6fadva9aa9gdhqrvrb9q28ih0ifdbd3hbp39j1k7ncvy27q473";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
