{
  # nix build inputs
  lib,
  buildHomeAssistantComponent,
  material-symbols-src,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${material-symbols-src}/custom_components/material_symbols/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "beecho01";

    inherit (manifest) domain version;
    src = material-symbols-src;

    meta = {
      license = lib.licenses.cc-by-nc-sa-40;
      homepage = "https://github.com/beecho01/material-symbols";
      description = ''
        Material Symbols for Home Assistant is a collection of 13,803 Google Material Symbols
        for use within Home Assistant. It uses the icon-set produced and maintained by iconify.
      '';
    };
  }
