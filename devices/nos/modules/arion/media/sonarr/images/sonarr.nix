pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:230ebe3521fbfc5fd7b30e169e3219953a132bdfcca88ef595360e1364e477e8";
  sha256 = "0bjpx1vbisfghqlikpyrp33af7c5wj3d546xqxgfl64bn4v0z0iw";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
