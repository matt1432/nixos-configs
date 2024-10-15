{
  capitalise,
  mkVersion,
  pkgs,
  self,
}: {
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

  buildNodeTypes = {
    configPath,
    packages,
    pname,
  }: let
    inherit (pkgs.lib) concatMapStrings elemAt filter hasAttr length map optionalString splitString toLower;

    withGirNames =
      map (package: {
        inherit package;
        girName =
          if package.pname == "astal-wireplumber"
          then "AstalWp-0.1"
          else (concatMapStrings capitalise (splitString "-" package.pname)) + "-0.1";
      })
      (filter (hasAttr "pname") packages);
  in {
    "${configPath}${optionalString (length packages == 1) "/${toLower (elemAt withGirNames 0).girName}"}".source =
      pkgs.callPackage
      ./mk-types {
        inherit (self.inputs) ts-for-gir-src;
        inherit pname withGirNames;
      };
  };
}
