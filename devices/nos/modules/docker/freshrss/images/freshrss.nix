pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:2edf78120d06de267864a9d4affbd8158f23e668cf569e273f7f6e755c73b0a5";
  sha256 = "1zw6h95bi6dj9n21zdfk7jc8w9pjbrm5fq76byj9crp7aq50sbpj";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
