pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:332384721b089afb03f912ae733195d1c6a30f4ab1b02209cfe02a7e6fbdab8c";
  hash = "sha256-VBqhfuEtJIw+66zRXSWDE3dAUDAlkuXZfK6qyoRJR+c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
