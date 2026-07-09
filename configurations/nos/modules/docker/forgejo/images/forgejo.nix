pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:9e14382433760127c87cb78c4dbc44b45abbb0c09c8479812c8e99b3dc893429";
  hash = "sha256-mJNai+l3cwws0VkyaWuGSHZyDdmBgHZzIh7d400IEZU=";
  finalImageName = imageName;
  finalImageTag = "15";
}
