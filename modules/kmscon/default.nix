{ ... }: {
  services.kmscon = {
    enable = true;
    hwRender = true;
    # FIXME: https://github.com/Aetf/kmscon/issues/18    // Icons not rendering properly
    # FIXME: https://github.com/Aetf/kmscon/issues/56    // Mouse cursor stays
    extraOptions = "--font-size 12.5 --font-dpi 170 --font-name 'JetBrainsMono Nerd Font'";
  };
}
