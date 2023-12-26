{
  config,
  pkgs,
  nixpkgs,
  ...
}: let
  secrets = config.sops.secrets;
  vars = config.vars;
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  systemd = {
    services.buildAll = {
      serviceConfig = {
        Type = "oneshot";
        User = vars.user;
        Group = config.users.users.${vars.user}.group;
      };
      script = ''
        cd /tmp
        ${pkgs.nix}/bin/nix-shell \
          -I "nixpkgs=${nixpkgs}" \
          -p openssh nix git nixci --run \
        "${builtins.concatStringsSep "; " [
          "git clone https://git.nelim.org/matt1432/nixos-configs.git nix-clone"
          "cd nix-clone"
          "nix flake update"
          "nixci ."
          "cd .."
          "rm -r nix-clone"
        ]}"
      '';
    };
    timers.buildAll = {
      wantedBy = ["timers.target"];
      partOf = ["buildAll.service"];
      timerConfig.OnCalendar = ["*-*-* 0:00:00"];
    };
  };
}
