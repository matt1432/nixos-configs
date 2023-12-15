{config, ...}: {
  services.kmscon = {
    enable = true;
    hwRender = false;
    # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
    extraOptions = builtins.concatStringsSep " " [
      "--font-size 12.5"
      "--font-dpi 170"
      "--xkb-layout ${config.services.xserver.layout}"
      "--xkb-variant ${config.services.xserver.xkbVariant}"
      "--font-name 'JetBrainsMono Nerd Font'"
    ];
  };
}
