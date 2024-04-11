pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:335388a2b30603bcd69d7411f3bfb37c54a8799eb1f76bae1f42ec6b2f9a5a79";
  sha256 = "0k423bbvq39jl2r68kj9za0dccr48d8zh40jqpwj3ssnffzb64nj";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
