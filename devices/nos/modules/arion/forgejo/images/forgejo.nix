pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:7aa26f80fb574cf7dc886e180d1e86462bf4110fd1d5343af33264c18ae3a1b3";
  sha256 = "1ij5cwbs8mv67pimkp43ia0fxli2rr5agy08sq8yimxmz4ayd60l";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "1.21.10-0";
}
