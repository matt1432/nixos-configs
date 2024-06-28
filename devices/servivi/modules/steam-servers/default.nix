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
      };
    };
  };
}
