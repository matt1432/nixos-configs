{nix-gaming, ...}: {
  imports = [nix-gaming.nixosModules.pipewireLowLatency];

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    # FIXME: https://github.com/fufexan/nix-gaming/issues/161
    lowLatency.enable = false;
  };
}
