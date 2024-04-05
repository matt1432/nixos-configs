pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:0097562444db38ebd2e5f98e71bd27dc6dd69b7f786207f7d323febbf99b8f93";
  sha256 = "09iyqs2fspi021005iw510b6xj87lfwimng84izbxvya7l312kb0";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.101.0";
}
