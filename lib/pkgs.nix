pkgs: mkVersion: {
  buildPlugin = pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = mkVersion src;
    };

  buildNodeModules = dir: npmDepsHash: let
    pkg = pkgs.callPackage ({buildNpmPackage, ...}: let
      inherit (builtins) readFile fromJSON;

      packageJSON = fromJSON (readFile (dir + /package.json));
    in
      buildNpmPackage {
        pname = packageJSON.name;
        inherit (packageJSON) version;

        src = dir;

        inherit npmDepsHash;
        dontNpmBuild = true;
      }) {};
  in "${pkg}/lib/node_modules/${pkg.pname}/node_modules";
}
