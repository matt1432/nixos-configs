pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:851c02f28891f1854c5b5762ee8d2e254e2de528cfe3627b2fbcb37a7f108ff3";
  sha256 = "02x48335crrvw1981wy3cp4668jl8r7qddz7jjr87yiisk0jvx58";
  finalImageName = imageName;
  finalImageTag = "release";
}
