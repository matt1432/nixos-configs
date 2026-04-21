pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:c4cbd5121236ac2f70a843a0b920b68a27976be57917555f1c45b08a1e6b2aad";
  hash = "sha256-WIXd3+p299CcjF69sfPSPDX73y1w7kiUoR2MyKV6YC8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
