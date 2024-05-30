{
  config,
  nix-eval-jobs,
  nix-fast-build,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (config.sops) secrets;

  nix-eval-jobsPkg =
    nix-eval-jobs.packages.${pkgs.system}.default.override {
      nix = config.nix.package;
    }
    // {
      nix = config.nix.package;
    };

  nix-fast-buildPkg = nix-fast-build.packages.${pkgs.system}.nix-fast-build.override {
    nix-eval-jobs = nix-eval-jobsPkg;
  };
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  environment.systemPackages = [
    nix-fast-buildPkg
  ];

  # Populate cache
  systemd = {
    services.buildAll = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path =
        [
          nix-fast-buildPkg
        ]
        ++ (with pkgs; [
          git
          openssh
        ]);

      script = ''
        cd /tmp
        if [[ -d ./nix-clone ]]; then
            rm -r ./nix-clone
        fi
        git clone https://git.nelim.org/matt1432/nixos-configs.git nix-clone
        cd nix-clone
        nix-fast-build
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
