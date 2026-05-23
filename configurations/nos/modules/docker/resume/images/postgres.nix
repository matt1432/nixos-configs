pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:8ff36f3c66371cba71d20ceedccfc3de9669a68737607888c4ef0af93abe8e39";
  hash = "sha256-cbcc05Vhh7jdbJnvfJCKW4SqpiYYap1uuBxmWZ92Suo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
