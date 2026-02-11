pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:ca3fca1093897b11dd1319d6b28d42d86ba5e2cff0fdfbdd4dcf448a0b76c795";
  hash = "sha256-qI2400nLhgX9ZF+a1zyJtyRXAAvuTQyMFGXzJtMPxa4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
