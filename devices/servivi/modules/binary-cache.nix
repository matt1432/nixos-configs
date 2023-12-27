{
  config,
  pkgs,
  ...
}: let
  secrets = config.sops.secrets;
  vars = config.vars;
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  # Populate cache
  systemd = {
    services.buildAll = {
      serviceConfig = {
        Type = "oneshot";
        User = vars.user;
        Group = config.users.users.${vars.user}.group;
      };

      path = with pkgs; [
        git
        nix
        nixci
        openssh
      ];

      script = ''
        cd /tmp
        git clone https://git.nelim.org/matt1432/nixos-configs.git nix-clone
        cd nix-clone
        nix flake update
        nixci .
        cd ..
        rm -r nix-clone
      '';
    };
    timers.buildAll = {
      wantedBy = ["timers.target"];
      partOf = ["buildAll.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
