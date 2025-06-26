pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:b515d79a4f7aa4bbbdfe45376d996a9bae2794faa16aca5a2beab0dba0c0b074";
  hash = "sha256-l3yYFGyoYZ9gOxjT5OYSZ5hvjVMa6QJzwnuGOdO75gY=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
