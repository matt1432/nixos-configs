pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:664812ebccd668d1771f6daf6ce03309b1b3587022a7bd540ecb90d0d2a8f003";
  sha256 = "06h39x1cxh9dwpramvv6bgfay6dnbyx264wf23hkf7hh48ylmb5b";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
