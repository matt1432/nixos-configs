{
  pkgs,
  steam-servers,
  ...
}: {
  imports = [steam-servers.nixosModules.default];

  services.steam-servers."7-days-to-die" = {
    mainServ = {
      enable = true;
      package = pkgs.callPackage ./seven-days.nix {};

      config = {
        ServerName = "bruh moment";
        ServerPort = 26900;

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
