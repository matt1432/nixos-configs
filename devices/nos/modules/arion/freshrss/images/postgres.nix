pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:21a1b037ebe0d3b7edefe4bc4352634883d4ba4fa7b7641bf86afa3219a47547";
  sha256 = "07v1r0ijag2kyr9nk5l7kphgvrb6lk71zyab4i31rkl1k27vfhwg";
  finalImageName = "postgres";
  finalImageTag = "14";
}
