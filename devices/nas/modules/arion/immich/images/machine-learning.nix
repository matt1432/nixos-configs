pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:5368a24201ce4ad4b2f81b892a69fb46006b3217e5961d5ee709176f4714e075";
  sha256 = "18r9mkhkblry3s3c20iq9qbr48g510xd4g7xw8jqd9w5m3gxf7hr";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.96.0";
}
