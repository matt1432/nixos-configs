pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:f5ee3fc67479c4015002b6b756ad7980cd8642f45376fc9cd073969c3292530b";
  hash = "sha256-CiKwnCLLGYLMqj4ylEhk1Cw/SyOMt059ZNdiWMtMIc8=";
  finalImageName = imageName;
  finalImageTag = "12";
}
