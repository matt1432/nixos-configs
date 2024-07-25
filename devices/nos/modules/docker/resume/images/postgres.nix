pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:468d34fefd6338031787c7b8e94078975b3aaf4d66c7ead25c39cd3ba46a15c6";
  sha256 = "1pg0rwqyzlhrik4x4bkx416qb034xrd0nmsckqd9w6ncsmppibvm";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
