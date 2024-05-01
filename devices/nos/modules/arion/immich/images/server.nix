pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:1ae17f5ce8e948f4268c95781904e6ef4bec99634ed43ebe2b0096c005932b7a";
  sha256 = "0ifbxds9q71a8lgd1c257is0pmhhi1pj8kpqqynw34clqj0pa5m4";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.103.0";
}
