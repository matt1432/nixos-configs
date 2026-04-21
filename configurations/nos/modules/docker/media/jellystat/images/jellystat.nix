pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:bb7ebe42424dedeff52d8da4130232d67e3fdd6dc2dd4a66091e32ddd835ea42";
  hash = "sha256-ojmJH/CAUQe9l4JQMfqLTMjqhfxt2b/pR4C1zIIz8iY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
