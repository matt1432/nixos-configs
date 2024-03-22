{
  buildGoModule,
  curseforge-server-downloader-src,
  ...
}:
buildGoModule {
  pname = "curseforge-server-downloader";
  version = "unstable";

  src = curseforge-server-downloader-src;
  doCheck = false;
  vendorHash = null;
}
