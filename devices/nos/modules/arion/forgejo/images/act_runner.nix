pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:01f8359d5e1bbb7aa614acffebf81bea6ffce4f9fb9e57872466df381103a4bd";
  sha256 = "0khlyh7naff3yl5mmww154z48l4ykgnql30d3msqpzd3g1j08jw7";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
