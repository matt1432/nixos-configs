pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:61b1c86c459fa52d0653516f573702791e611574737dc76175ae9d2628c911f5";
  hash = "sha256-5XVjj02Lx3lJ3qYYye6mVJBTLITIEyNPMwfFgSBVlIc=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
