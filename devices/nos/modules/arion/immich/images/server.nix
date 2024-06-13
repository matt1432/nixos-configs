pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:80b9e59c55869ec3f4cfa204ce1ad096356252b834b5cc2b6421dff69aaa2e8a";
  sha256 = "0k7qwk02r92kq852j4zw8i4kjczldpkkcw5iqmn0dk3r1zzy9n2y";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.106.3";
}
