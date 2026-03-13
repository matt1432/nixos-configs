pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:9ef5d8bf832edcacb6082f9262cb36087854e78eb7b1c3e1d4375056055b2d82";
  hash = "sha256-7kBGR9o0MNe1VKR7uUCFbDFAs8yVi6CK0JhbT/IA+G8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
