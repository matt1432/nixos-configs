pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:ec444338a67e429a20f6eef938e1ed771ce357ed4831765026096061a09bbbb7";
  hash = "sha256-Zzv/9axb/ovtuKGgJ4p2pf3JLkisaGoStP12Kro1ylE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
