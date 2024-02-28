{nix-gaming, ...}: {
  imports = [nix-gaming.nixosModules.pipewireLowLatency];

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;
    lowLatency.enable = true;
  };
}
