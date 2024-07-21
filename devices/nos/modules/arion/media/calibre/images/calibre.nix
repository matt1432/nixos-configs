pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:8db829132ee053bfdb0fd5835c25d357af396048ea2d4666ca1e21a715a3b45e";
  sha256 = "0zkm6rf678xjnngdn1agzq8k7jx3qdiljk990ynw7vbszbz0rzdh";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
