pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:a1a2885261a0b8337d4791dd6949651117206741ba66423c24a57c107a64d4a8";
  hash = "sha256-ZtyQ1aLBTD+Pfn4wERQYffOPubFvE0bY7TpPenbFQlY=";
  finalImageName = imageName;
  finalImageTag = "12";
}
