{
  config,
  mainUser,
  pkgs,
  ...
}: {
  virtualisation.docker.compose."jdownloader2".services."jdownloader2" = {
    image = pkgs.callPackage ./images/jdownloader2.nix pkgs;
    restart = "always";

    environment = {
      USER_ID = toString config.users.users.${mainUser}.uid;
      GROUP_ID = toString config.users.users.${mainUser}.uid;
      KEEP_APP_RUNNING = 1;
      TZ = "America/New_York";
    };

    ports = [
      "5800:5800"
    ];

    volumes = [
      "/var/lib/jdownloader2:/config:rw"
      "/data/downloads/comics:/output:rw"
    ];
  };
}
