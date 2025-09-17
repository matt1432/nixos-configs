pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/postgres";
  imageDigest = "sha256:dc9a4dc44b228aba661f76ead06ef142a16c4f57ae9d77cdb9d50f6667e3065c";
  hash = "sha256-I0CooKincACIZezgXapip6aXhhq/bRFzG0al7KZRlus=";
  finalImageName = imageName;
  finalImageTag = "14-vectorchord0.3.0-pgvectors0.2.0";
}
