{
  nixpkgs,
  pkgs,
  ...
}: {
  programs = {
    wofi = {
      enable = true;
      # FIXME: remove when overlay gets fixed
      package = pkgs.callPackage "${nixpkgs}/pkgs/applications/misc/wofi/default.nix" {};
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
