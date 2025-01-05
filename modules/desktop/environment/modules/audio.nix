self: {
  config,
  lib,
  ...
}: let
  inherit (self.inputs) nix-gaming;

  inherit (lib) mkIf;

  cfg = config.roles.desktop;
in {
  imports = [nix-gaming.nixosModules.pipewireLowLatency];

  config = mkIf cfg.enable {
    services = {
      pulseaudio.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        jack.enable = true;
        pulse.enable = true;
        lowLatency.enable = true;

        extraConfig.pipewire-pulse.combine-sink = {
          "pulse.cmd" = [
            {
              cmd = "load-module";
              args = "module-combine-sink";
            }
          ];
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./audio.nix;
}
