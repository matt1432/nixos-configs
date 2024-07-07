{pkgs, ...}: let
  gamePath = "/var/lib/steam-servers/7-days-to-die";
in {
  systemd.extraConfig = "DefaultLimitNOFILE=10240";

  # https://github.com/Krutonium/NewNix/blob/455aafc4caf553248ca228f844f021cecf494dc2/services/sevendaystodie.nix#L6
  systemd.services."7daystodie" = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    serviceConfig.User = "matt";

    path = with pkgs; [steam-run steamcmd];
    script = ''
      mkdir -p ${gamePath}
      cd ${gamePath}
      steamcmd +force_install_dir ${gamePath} +login anonymous +app_update 294420 -beta latest_experimental +quit
      steam-run ./startserver.sh -configfile=serverconfig-7days.xml
    '';
  };
}
