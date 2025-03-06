attr: selfPath: let
  inherit (builtins) currentSystem getFlake mapAttrs removeAttrs replaceStrings;

  self = getFlake selfPath;
  scopes = ((import "${selfPath}/${attr}" {description = true;}) {} {}).scopedPackages;

  trimNewlines = s: replaceStrings ["\n"] [" "] s;
in {
  attrs =
    mapAttrs (n: v: {
      desc = trimNewlines v;
      packages = let
        scopePkgs = removeAttrs self.${attr}.${currentSystem}.${n} [
          "buildFirefoxXpiAddon"
          "callPackage"
          "newScope"
          "override"
          "overrideDerivation"
          "overrideScope"
          "packages"
          "recurseForDerivations"
        ];
      in
        mapAttrs (_: pkg: {
          desc = trimNewlines (pkg.meta.description or "");
          homepage = pkg.meta.homepage or "";
        })
        scopePkgs;
    })
    scopes;
}
