pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:76e946b330af2b457777b8c829de2e02d911ca85aafd083975fa167fa12ff7c8";
  hash = "sha256-TmJLo/wadadzn03MAPrYBKhCIHO7+JW0oIpQ6GjSicU=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
