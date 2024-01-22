{config, ...}: let
  servivi = "100.64.0.7";
in {
  # https://nixos.wiki/wiki/Distributed_build
  home-manager.users.root = {
    home.file.".ssh/config".text =
      /*
      ssh_config
      */
      ''
        Host ${servivi}
          # Prevent using ssh-agent or another keyfile, useful for testing
          IdentitiesOnly yes
          IdentityFile ${config.sops.secrets.nixremote.path}

          # The weakly privileged user on the remote builder – if not set,
          # 'root' is used – which will hopefully fail
          User nixremote
      '';
  };

  programs.ssh.knownHosts = {
    ${servivi}.publicKey = "servivi ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkNW0H4Fl6NFgahlgGbSvglg1DrX4yl1ht9Lp+vHE2A";
  };

  nix = {
    buildMachines = [
      {
        hostName = servivi;
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 1;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
    # optional, useful when the builder has a faster internet connection than yours
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
