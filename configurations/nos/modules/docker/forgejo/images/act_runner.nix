pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:59ddfdc7e592b72665f86d3c4d7d83ff07a5ddfd711e627a1a8eaca0bd76be23";
  sha256 = "052a9hqzq8xv2lzwy7il182pb9f854kq6z2pagpf09mgqx4b2bdb";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
