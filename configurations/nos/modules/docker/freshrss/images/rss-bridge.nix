pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:7ef08306974ec1017e5423f081a51be18df3a82773266cb8753a73ff27843db8";
  hash = "sha256-eP22J6Ek35qAafuaynBYa71E5zDSQ0Z0pQr5LN3Jmzg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
