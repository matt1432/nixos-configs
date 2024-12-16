{lib, ...}: let
  inherit (lib) concatMapStringsSep concatStringsSep;
in {
  services.nfs.server = {
    enable = true;
    createMountPoints = true;

    exports = let
      mkExport = dir: opts: ips: "/export${dir} ${
        concatMapStringsSep " "
        (ip: ip + "(${concatStringsSep "," opts})")
        ips
      }";

      mkRootExport = opts: ips:
        mkExport "" (opts ++ ["crossmnt" "fsid=0"]) ips;

      allowedIps = ["10.0.0.244" "100.64.0.8" "10.0.0.159" "100.64.0.9"];
      options = ["rw" "no_root_squash" "no_subtree_check"];
    in ''
      ${mkRootExport options allowedIps}
      ${mkExport "/caddy" options allowedIps}
      ${mkExport "/headscale" options allowedIps}
    '';
  };
}
