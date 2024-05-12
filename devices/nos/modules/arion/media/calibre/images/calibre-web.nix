pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:699a678b4240d2a2d8bd36630e2fce001e3b1c5bd7f2ae1664e24dda947c3a66";
  sha256 = "1pdrj6c641akfk1p66iipffn5sg0qr85yvc6cllrd2jcbs67y4cj";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
