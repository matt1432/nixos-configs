pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:378efec2a8f9e17874965b6a03ea935b0195eb85bdf60305eee994f684134f27";
  sha256 = "1g5apdg8mycda2rwfnfjr3h5005l3gn2i2s5zywiijfx6piif3k4";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
