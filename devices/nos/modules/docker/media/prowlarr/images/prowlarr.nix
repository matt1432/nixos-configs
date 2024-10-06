pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:806916104582ff18024b1234a0c82e113c160037f0bf0e6c076e14528bbab331";
  sha256 = "11wwcxn7m8nq7khl9vi97blxr0fwq0d3il53jq9bl09wncbg4in9";
  finalImageName = imageName;
  finalImageTag = "latest";
}
