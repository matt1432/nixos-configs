{config, ...}: let
  inherit (config.services.xserver) xkb;
in {
  services.kmscon = {
    enable = true;
    hwRender = false;
    # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
    extraOptions = builtins.concatStringsSep " " [
      "--font-size 12.5"
      "--font-dpi 170"
      "--xkb-layout ${xkb.layout}"
      "--xkb-variant ${xkb.variant}"
      "--font-name 'JetBrainsMono Nerd Font'"
    ];
  };
}
