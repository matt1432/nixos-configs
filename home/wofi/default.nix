{...}: {
  programs = {
    wofi = {
      enable = true;
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
