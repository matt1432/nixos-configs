pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:e790e8ba8c41b10e9a98a3f035cf5ee41d717db5bb1b4cd2f02c2de45670470c";
  sha256 = "0nyrdcvhpqldl8fgvsfzhmj1xygw8fdj6aqypv3q0l5yiw358jrm";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
