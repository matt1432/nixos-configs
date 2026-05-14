pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:4407d9f9a4a5b8ef2e382827782b3dd6e0ecf8f2832ecb0344601691c13da149";
  hash = "sha256-JYF5uAgZwxLvsl1TwcoSuafEGg8P1o1WpF5BT0U+JUI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
