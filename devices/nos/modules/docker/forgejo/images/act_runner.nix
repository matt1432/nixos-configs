pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:0f2cedb38b779319f005dea39b1ac532757aa52bf327d93e2a2d8d82a50b04eb";
  sha256 = "06gm6q8ss4dkmj8vp02wmfsw4bjy8v2n4wk2n8l7ydi6qadd4w3d";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
