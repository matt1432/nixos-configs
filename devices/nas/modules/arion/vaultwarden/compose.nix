{config, ...}: let
  inherit (config.arion) rwDataDir;

  rwPath = rwDataDir + "/vaultwarden";
in {
  arion.projects."vaultwarden" = {
    "public-vault" = {
      image = ./images/vaultwarden.nix;
      restart = "always";

      ports = ["8781:80"];
      volumes = ["${rwPath}/public-data:/data"];
      environment.WEBSOCKET_ENABLED = "true";
    };

    "private-vault" = {
      image = ./images/vaultwarden.nix;
      restart = "always";

      ports = ["8780:80"];
      volumes = ["${rwPath}/private-data:/data"];
      environment.WEBSOCKET_ENABLED = "true";
    };
  };
}
