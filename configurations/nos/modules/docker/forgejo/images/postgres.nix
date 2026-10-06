pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:ceef4a62198b562d6fe3e51be67362f72a0abf0aaa255f54f0c0e55be9768ed2";
  hash = "sha256-rIj2V9eX3+yF48EqyRY8yWvgGzevYTeQJf09BY470YQ=";
  finalImageName = imageName;
  finalImageTag = "14";
}
