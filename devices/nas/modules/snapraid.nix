{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    attrValues
    filterAttrs
    hasPrefix
    listToAttrs
    mapAttrs
    optionalString
    substring
    toInt
    ;

  parityDrives = filterAttrs (n: v: hasPrefix "p" n) config.fileSystems;
  dataDrives = filterAttrs (n: v: hasPrefix "d" n) config.fileSystems;
in {
  snapraid = {
    enable = true;

    dataDisks = listToAttrs (attrValues (mapAttrs (n: fs: {
        name = substring 0 2 n;
        value = fs.mountPoint;
      })
      dataDrives));

    parityFiles = attrValues (mapAttrs (n: fs: "${fs.mountPoint}/snapraid.${
        let
          i = (toInt (substring 1 1 n)) + 1;
        in
          optionalString (i != 1) "${toString i}-"
      }parity")
      parityDrives);

    contentFiles =
      ["/var/snapraid/content"]
      ++ map (fs: "${fs.mountPoint}/content") (attrValues dataDrives);

    exclude = [
      "*.bak"
      "*.unrecoverable"
      "/tmp/"
      "/lost+found/"
      ".AppleDouble"
      "._AppleDouble"
      ".DS_Store"
      ".Thumbs.db"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".AppleDB"
    ];
  };
}
