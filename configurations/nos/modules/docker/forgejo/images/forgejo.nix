pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:55bb42bec9abef5223744804f164e37d37b20df7e8b8b4807ba213ad4f071d6d";
  hash = "sha256-1BKy7esLIwXIYCGmulWKMA+XnQR+JWe+AQLtbCMGJiA=";
  finalImageName = imageName;
  finalImageTag = "15";
}
