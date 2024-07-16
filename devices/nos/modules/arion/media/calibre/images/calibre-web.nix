pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:0caef2dc9c26f29623c42b2e6496274224ae79efc99849db53d08f9a5224b4f2";
  sha256 = "0xp4f91sj492wkmygmijwni694mzvh6p1y5v9z7zm4058hxmly3j";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
