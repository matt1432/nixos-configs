{
  config,
  mainUser,
  pkgs,
  ...
}: {
  virtualisation.docker.compose."mylar3".services."mylar3" = {
    image = pkgs.callPackage ./images/mylar3.nix pkgs;
    restart = "always";

    environment = {
      PUID = toString config.users.users.${mainUser}.uid;
      PGID = toString config.users.users.${mainUser}.uid;
      TZ = "America/New_York";
    };

    ports = [
      "8090:8090"
    ];

    volumes = [
      "/var/lib/mylar3:/config"
      "/data/comics:/comics"
      "/data/downloads/comics:/downloads"
      "/data/downloads/watch-comics:/watch"
    ];
  };
}
