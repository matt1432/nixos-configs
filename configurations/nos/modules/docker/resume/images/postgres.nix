pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:e754b839f447639b7004895f4d8a4bfcb4e9dbe3a1bc035f27f646562a16fd61";
  hash = "sha256-FkV5HFRZd8mqP38ccmyLdWxP8MOQKlrCpya3tOKhWhk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
