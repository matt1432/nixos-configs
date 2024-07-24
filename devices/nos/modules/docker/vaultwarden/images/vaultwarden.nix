pkgs:
pkgs.dockerTools.pullImage {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:4e28425bad4bd13568e1779f682ff7e441eca2ecd079bd77cfcba6e4eaf1b999";
  sha256 = "1iq3siiwya4qg65h07fpnvfm0isj1h86addaljk76bqi1ms9kk2j";
  finalImageName = "quay.io/vaultwarden/server";
  finalImageTag = "latest";
}
