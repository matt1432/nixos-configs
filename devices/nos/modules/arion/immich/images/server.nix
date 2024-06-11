pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7c853eee0f9a6f742dafe71db64486a34067f24d253cba3ddc7b7eaa7420f00c";
  sha256 = "0h8zzdqap3rciibgv2cg6nfcc3493vflwl6vrl936dgvi6ldjq9b";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.106.2";
}
