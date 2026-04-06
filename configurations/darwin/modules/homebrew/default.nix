{...}: {
  homebrew = {
    enable = true;

    casks = [
      # To finish setup, launch Docker GUI
      "docker-desktop"

      # Color picker
      "pika"

      "spotify"
    ];
  };
}
