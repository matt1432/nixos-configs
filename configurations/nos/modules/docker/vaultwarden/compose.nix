{configPath, ...}: {pkgs, ...}: let
  rwPath = configPath + "/vaultwarden";
in {
  virtualisation.docker.compose."vaultwarden" = {
    networks.proxy_net = {external = true;};

    services = {
      "public-vault" = {
        image = pkgs.callPackage ./images/vaultwarden.nix pkgs;
        restart = "always";

        ports = ["8781:80"];
        volumes = ["${rwPath}/public-data:/data"];
        environment.WEBSOCKET_ENABLED = "true";
        networks = ["proxy_net"];
      };

      "private-vault" = {
        image = pkgs.callPackage ./images/vaultwarden.nix pkgs;
        restart = "always";

        ports = ["8780:80"];
        volumes = ["${rwPath}/private-data:/data"];
        environment.WEBSOCKET_ENABLED = "true";
        networks = ["proxy_net"];
      };
    };
  };

  # For accurate stack trace
  _file = ./compose.nix;
}
