pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:2f7365d1f574dba34f6332978169afe60af9de9608fffbbfecb7d04cc5233698";
  sha256 = "07v1r0ijag2kyr9nk5l7kphgvrb6lk71zyab4i31rkl1k27vfhwg";
  finalImageName = "postgres";
  finalImageTag = "14";
}
