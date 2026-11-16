pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:7bf70dcb85c822e3fa6f2d332143e474b99147b9d7b39102b0cfe8b04a7dd61b";
  hash = "sha256-LegYv/pf7qg3AdVg4Q1/DqbRFBqYQ2NQiTzXm5nqDG8=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
