pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d40ee61030a9afafddfdd58d160281b865bfcad7cb66e920116fd6fd40668cbb";
  hash = "sha256-u00wtj+IyO6RK8NoqOSXJBMRcJSNhStYAWWbPV/fviw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
