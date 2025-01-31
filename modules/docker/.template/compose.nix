rwDataDir: {config, ...}: let
  inherit (config.sops) secrets;

  rwPath = rwDataDir + "/projectName";
in {
  virtualisation.docker.compose."projectName" = {
    services = {};
  };

  # For accurate stack trace
  _file = ./default.nix;
}
