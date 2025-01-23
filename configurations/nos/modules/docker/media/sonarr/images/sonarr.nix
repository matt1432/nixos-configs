pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:7f593f902c27aeb269cd92d3667049e62038540058b086bb32ec1711918f4503";
  hash = "sha256-x3eQfV4kUsQqbn/apGFKnRfcWdXfXsg+eDNf47w3JSM=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
