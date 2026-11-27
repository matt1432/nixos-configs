pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:b3db4247d3afa0c68bc5aa311bedd67b1caf4b3eabc3a85577682970435d5013";
  hash = "sha256-VNFlcGqnP7kl80k2/ACui+jIE+ne0krSdiIkjB3lrJk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
