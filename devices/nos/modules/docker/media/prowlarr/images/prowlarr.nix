pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:9dd32e2270d174b07bd33a1f54e2b79e03ad944df62ed93efa08f4a381adc9a1";
  sha256 = "1kx10is1zzwrgdz6y7i98jk3vmx7rv74dpgicimb1msdy9qm7m70";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
