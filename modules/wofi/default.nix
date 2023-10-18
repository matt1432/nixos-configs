# Home-manager module

{ nixpkgs-wayland, ... }: {
  programs = {
    wofi = {
      enable = true;
      package = nixpkgs-wayland.packages.x86_64-linux.wofi;
      settings = {
        prompt = "";
        allow_images = true;
        normal_window = true;
        image_size = "48";
        matching = "fuzzy";
        insensitive = true;
        no_actions = true;
      };
      style = builtins.readFile ./style.css;
    };
  };
}
