pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4e8c2e92ad1fa2c3ea5efca42540e626a362d467e50bec75f9afecf2666f2f5b";
  hash = "sha256-66K3Taz+Y9SLkBGrjG002BZyrBe3ufx7zOXKQDAVMqk=";
  finalImageName = imageName;
  finalImageTag = "14";
}
