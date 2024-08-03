{config, ...}: let
  inherit (config.sops) secrets;
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/projectName";
in {
  khepri.compositions."projectName" = {
    services = {};
  };
}
