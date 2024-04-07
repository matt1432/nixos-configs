pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:77eac601f294e03756edbee4ed4f748a539117c879bd79d514d1eac975cdca0f";
  sha256 = "0c4icjm4hrzw35zrrva5nnr2a1wyrcdq1p67q5jirskg73mxf7xg";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
