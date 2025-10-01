pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:328dc1698cc6f54bb811b8030ff864c6345144cded5ac89b6ab23fe9f747d723";
  hash = "sha256-O0FzJ8r8bj5CuU0vFmwnMlEfTUFfmco1XDroYlFbOa0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
