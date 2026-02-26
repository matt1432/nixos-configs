{...}: {
  homebrew = {
    enable = true;

    casks = [
      # To finish setup, launch Docker GUI
      "docker-desktop"

      # Color picker
      "pika"

      "spotify"

      # TODO: adapt <base/locale.nix> to support darwin
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
