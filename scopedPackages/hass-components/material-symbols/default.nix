{
  material-symbols-src,
  buildHomeAssistantComponent,
  ...
}: let
  inherit (builtins) fromJSON readFile;

  manifest = fromJSON (readFile "${material-symbols-src}/custom_components/material_symbols/manifest.json");
in
  buildHomeAssistantComponent {
    owner = "beecho01";

    inherit (manifest) domain version;
    src = material-symbols-src;
  }
