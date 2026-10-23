pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:ff546679970126f8822e15d1b6a06bfbff1f2ce2e43f810cfb5258012f92de5c";
  hash = "sha256-s+fCr0Oqr9B+0cAwEJmI5650OsiAKafMFukiqKYSA9c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
