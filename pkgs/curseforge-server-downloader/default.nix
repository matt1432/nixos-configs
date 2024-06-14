{
  buildGoModule,
  curseforge-server-downloader-src,
  mkVersion,
  ...
}:
buildGoModule {
  pname = "curseforge-server-downloader";
  version = mkVersion curseforge-server-downloader-src;

  src = curseforge-server-downloader-src;
  doCheck = false;
  vendorHash = null;
}
