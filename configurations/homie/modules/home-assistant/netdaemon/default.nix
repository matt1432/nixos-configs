{
  config,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (config.sops) secrets;

  inherit (pkgs.callPackage ./package.nix {}) netdaemonConfig;
in {
  virtualisation.docker.compose."netdaemon" = {
    networks.netdaemon = {external = true;};

    services."netdaemon5" = {
      image = pkgs.callPackage ./images/netdaemon.nix pkgs;
      restart = "always";

      env_file = [secrets.netdaemon.path];
      environment = {
        HomeAssistant__Host = "homie.nelim.org";
        HomeAssistant__Port = "443";
        HomeAssistant__Ssl = "true";
        NetDaemon__ApplicationAssembly = "netdaemon.dll";
        Logging__LogLevel__Default = "Information"; # use Information/Debug/Trace/Warning/Error
        TZ = "America/New_York";
      };

      volumes = ["${netdaemonConfig}:/data"];
      networks = ["netdaemon"];
    };
  };

  services.home-assistant = {
    customComponents = attrValues {
      inherit
        (pkgs.scopedPackages.hass-components)
        netdaemon
        ;
    };
  };
}
