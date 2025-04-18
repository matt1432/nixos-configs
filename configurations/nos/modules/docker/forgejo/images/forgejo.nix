pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:e7663b58cc0a1610f31b315150e4fa8a00f6936d98abd6e26ef247f009cc7f52";
  hash = "sha256-wqXqOYhXkY4F4aQ2I6o1c6FZ/VyarJaur/rELD9v3iA=";
  finalImageName = imageName;
  finalImageTag = "11";
}
