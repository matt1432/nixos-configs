pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:f26fd329f35b97bccdf5ee5a7b558df0ccf1e073a1d7a5787e433043e22b9296";
  hash = "sha256-qWcT+3l9MOAEDzfqEOmc7gfB0gkia5dJ3ziG/PMESgo=";
  finalImageName = imageName;
  # FIXME: https://docs.rxresu.me/self-hosting/migration
  finalImageTag = "v4.5.5";
}
