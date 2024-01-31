{
  buildGo120Module,
  curseforge-server-downloader-src,
  lib,
  ...
}:
buildGo120Module {
  pname = "curseforge-server-downloader";
  version = "unstable";

  src = curseforge-server-downloader-src;
  doCheck = false;
  vendorHash = null;
}
