pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:35a00cacfb7ffd7b225ddbb267bdfbaa3fc9cba09fe5a47a96d720bfb4bce869";
  sha256 = "0nfr1ss5xy50shcr3yc81nf9mv0vmpnpbgkhvridwagj2slrhb6j";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
