pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:30432d9faf9e8fbb7c6336806ee061ed426204e1f9718d9659a2642a6e3a7c59";
  sha256 = "034zqf7fqy472kdp6ygc9hw5wz00zq4v9xx2ccr546crcqsqkywm";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
