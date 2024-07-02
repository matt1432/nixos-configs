{
  pkgs,
  steam-servers,
  ...
}: {
  imports = [steam-servers.nixosModules.default];

  services.steam-servers."7-days-to-die" = {
    mainServ = {
      enable = true;
      package =
        steam-servers
        .packages
        .${pkgs.system}
        ."7-days-to-die"
        .branches
        .latest_experimental;

      config = {
        ServerName = "bruh moment";
        ServerPort = 26900;

        # removed in v1.0
        SaveGameFolder = null;

        BlockDamagePlayer = 200;
        BloodMoonEnemyCount = 10;
        DropOnDeath = 3;
        PartySharedKillRange = 10000;
        PlayerKillingMode = 2;
        XPMultiplier = 200;
        ZombieBMMove = 1;
        ZombieMoveNight = 0;
      };
    };
  };
}
