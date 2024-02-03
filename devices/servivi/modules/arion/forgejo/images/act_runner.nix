pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:0574f35eaf2e02083fbeb35134465f0def6d73f86a3596f63a94ec721a7f2003";
  sha256 = "0qfllkq82cnx3sw1wx7lywx0rh6qbmimkqqcr1zvix6nxka1cdsn";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
