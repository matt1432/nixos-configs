{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/projectName";
in {
  arion.projects."projectName" = {
  };
}
