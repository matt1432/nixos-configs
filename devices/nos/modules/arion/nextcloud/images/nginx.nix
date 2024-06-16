pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:56b388b0d79c738f4cf51bbaf184a14fab19337f4819ceb2cae7d94100262de8";
  sha256 = "099ivwfqsb1d8svj1kxy2bnvr8zwf4sgw4816dkghsb4jqnij270";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
