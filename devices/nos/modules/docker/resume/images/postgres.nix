pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:d98d4ee225766374077e2d689a4a20be9195c0c112dfc36ff9b54701d279e221";
  sha256 = "1pg0rwqyzlhrik4x4bkx416qb034xrd0nmsckqd9w6ncsmppibvm";
  finalImageName = "postgres";
  finalImageTag = "15-alpine";
}
