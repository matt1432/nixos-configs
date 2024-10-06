pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:7899093c3d34eaf1c4f12cd4bb31b3cb4e0ccfa3823b3661feff4561be69c823";
  sha256 = "17skcav0dbvpysqhzah4wspwqvfz4pkk93c9ycvm6gmhqqm6kgbx";
  finalImageName = imageName;
  finalImageTag = "latest";
}
