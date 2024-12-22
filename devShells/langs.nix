{
  pkgs,
  self,
  ...
}: let
  inherit (pkgs.lib) listToAttrs nameValuePair;
  mkLangsShells = langs:
    listToAttrs (map (l:
      nameValuePair l (pkgs.callPackage ../homeManagerModules/neovim/langs/${l}/shell.nix {inherit self;}))
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
