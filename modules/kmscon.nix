{...}: {
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    hwRender = false;

    # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
    extraOptions = builtins.concatStringsSep " " [
      "--font-size 12.5"
      "--font-dpi 170"
      "--font-name 'JetBrainsMono Nerd Font'"
    ];
  };
}
