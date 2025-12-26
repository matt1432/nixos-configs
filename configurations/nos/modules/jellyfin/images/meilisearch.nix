pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:1af40ecce0b3a21f9a4ff14defaa80da602af3d456ef40a81e83e20043e97485";
  hash = "sha256-oXLj3C9kFtHjSVrtpfMB7/Ud8o7/Key3QgtXk+qRECQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
