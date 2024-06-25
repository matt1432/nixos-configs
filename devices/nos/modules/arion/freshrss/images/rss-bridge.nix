pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:4c40659966f9717f88767b20407b811e2bed98f1a5230faf29009dcfba405fb1";
  sha256 = "0a9lfcgsvpajqh22j6fqb0zlnjphpifq2fgpnfwl7dkx9xp10qng";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
