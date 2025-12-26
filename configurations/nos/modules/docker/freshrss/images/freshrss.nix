pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:5664f42e37e7101c824806d8f73cbc97c8f406ce043bbdb8d39d4ff1e7f2ad11";
  hash = "sha256-RMG39htfHqCXDhjLbJr7v0P3i1NeOEHYg9B6wnfeh10=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
