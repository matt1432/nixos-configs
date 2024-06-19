pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:7ea2b97aeb277559240781b5f4d774fa53422affd1e0e9c1bef7dd2520bbdf23";
  sha256 = "1x66sh1jz6jnjj5xkx0lgs81zm4ilm8hh9yiimc4z7gj1k89b2cx";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
