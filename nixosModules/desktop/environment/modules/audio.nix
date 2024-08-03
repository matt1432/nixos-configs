self: {...}: let
  inherit (self.inputs) nix-gaming;
in {
  imports = [nix-gaming.nixosModules.pipewireLowLatency];

  config = {
    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      lowLatency.enable = true;
    };
  };

  # For accurate stack trace
  _file = ./audio.nix;
}
