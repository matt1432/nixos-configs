pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:1a70daa5c9a72bb0846602ef8ce16949ee4a6144f5577daed3c539c4e5b192de";
  sha256 = "139f4n6vbs93ai5zk3zm8dv4dqnj2zss80bzqyjqlj5vmyp6jqx3";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
