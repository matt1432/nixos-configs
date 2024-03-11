pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:869c8002a95c8ecef7b0359a36b13693cd2bf401c70482202c702f93bc264a04";
  sha256 = "0k29s6rbscg62kyr9mfidxz852x7f2zm6mc3j41wms8mhvpjxkld";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
