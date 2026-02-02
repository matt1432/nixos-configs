pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5773fe724c49c42a7a9ca70202e11e1dff21fb7235b335a73f39297d200b73a2";
  hash = "sha256-OYx9hoJgcHQenwc9sh1EfIr028CKyS9GSb4kuTkzwoQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
