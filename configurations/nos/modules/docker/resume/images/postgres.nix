pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a9abf4275f9e99bff8e6aed712b3b7dfec9cac1341bba01c1ffdfce9ff9fc34a";
  hash = "sha256-Kv1M6ltOare74+dGxSVe0rw3mQ7Ul5PM3VzpMbudPh8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
