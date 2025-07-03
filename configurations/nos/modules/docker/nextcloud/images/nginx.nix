pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:93230cd54060f497430c7a120e2347894846a81b6a5dd2110f7362c5423b4abc";
  hash = "sha256-Pqxa9pKUv50Ja4Y1HvjUMdBIcd4jJ8gvUBmmCupqWKQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
