{
  pkgs,
  self,
}: let
  inherit (builtins) readFile fromJSON;
  inherit (self.lib) mkVersion;
  inherit (pkgs.lib) concatStringsSep elemAt hasAttr length optionalString toLower;
in {
  buildPlugin = pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = mkVersion src;
    };

  buildNodeModules = dir: npmDepsHash: let
    packageJSON = fromJSON (readFile (dir + /package.json));

    pkg = pkgs.callPackage ({buildNpmPackage, ...}:
      buildNpmPackage {
        pname = packageJSON.name;
        inherit (packageJSON) version;

        src = dir;

        inherit npmDepsHash;
        dontNpmBuild = true;
      }) {};
  in "${pkg}/lib/node_modules/${pkg.pname}/node_modules";

  buildGirTypes = {
    configPath,
    packages,
    pname,
  }: let
    girNameTable = {
      gtk4 = ["Gtk-4.0"];
      gtk4-layer-shell = ["Gtk4LayerShell-1.0" "Gtk4SessionLock-1.0"];
      gtk-session-lock = ["GtkSessionLock-0.1"];
      libadwaita = ["Adw-1"];
    };

    withGirNames =
      map (package: let
      in {
        inherit package;
        girName =
          package.girName
          or (
            if hasAttr package.pname girNameTable
            then concatStringsSep " " girNameTable.${package.pname}
            else throw "girName of ${package.name} couldn't be found"
          );
      })
      packages;
  in {
    "${configPath}${optionalString (length packages == 1) "/${toLower (elemAt withGirNames 0).girName}"}" = {
      force = true;
      source = pkgs.callPackage ./mk-types {
        inherit (self.inputs) ts-for-gir-src;
        inherit pname withGirNames;
      };
    };
  };
}
