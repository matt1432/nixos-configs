{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) listToAttrs nameValuePair;
  mkLangsShells = langs:
    listToAttrs (map (
        l:
          nameValuePair
          l
          ((pkgs.callPackage
              "${self}/homeManagerModules/neovim/langs/${l}/shell.nix"
              ({} // pkgs.selfPackages))
            .overrideAttrs (o: {
              meta.description = "${l} shell to be loaded by my Neovim config dynamically.";
            }))
      )
      langs);
in
  mkLangsShells [
    "csharp"
    "json"
    "lua"
    "markdown"
    "rust"
    "web"
    "c-lang"
  ]
