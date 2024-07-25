{
  config,
  pkgs,
  ...
}: let
  inherit (config.khepri) rwDataDir;

  rwPath = rwDataDir + "/vaultwarden";
in {
  khepri.compositions."vaultwarden" = {
    networks.proxy_net = {external = true;};

    services = {
      "public-vault" = {
        image = import ./images/vaultwarden.nix pkgs;
        restart = "always";

        ports = ["8781:80"];
        volumes = ["${rwPath}/public-data:/data"];
        environment.WEBSOCKET_ENABLED = "true";
        networks = ["proxy_net"];
      };

      "private-vault" = {
        image = import ./images/vaultwarden.nix pkgs;
        restart = "always";

        ports = ["8780:80"];
        volumes = ["${rwPath}/private-data:/data"];
        environment.WEBSOCKET_ENABLED = "true";
        networks = ["proxy_net"];
      };
    };
  };
}
