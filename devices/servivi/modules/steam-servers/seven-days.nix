{
  lib,
  mkSteamPackage,
  gcc-unwrapped,
  zlib,
}:
mkSteamPackage {
  lockFile = ./lock.json;

  buildInputs = [
    gcc-unwrapped
    zlib
  ];

  meta = with lib; {
    description = "7 Days to Die dedicated server";
    homepage = "https://steamdb.info/app/294420/";
    changelog = "https://store.steampowered.com/news/app/251570?updates=true";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode # Steam games are always going to contain some native binary component.
      binaryBytecode # e.g. Unity games using C#
    ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
  };
}
