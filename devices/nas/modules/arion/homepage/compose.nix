{config, ...}: let
  inherit (config.arion) toYAML;
  inherit (config.sops) secrets;
in {
  arion.projects."homepage" = {
    "homepage" = {
      image = ./images/homepage.nix;
      restart = "always";

      ports = [
        "3020:3000"
      ];

      env_file = [secrets.homepage.path];

      volumes = let
        services = toYAML "services.yaml" (import ./services.nix);

        bookmarks = toYAML "bookmarks.yaml" {};

        settings = toYAML "settings.yaml" {
          # FIXME: title not working
          title = "bruh";
          theme = "dark";
          color = "gray";
          target = "_self";

          layout.video = {
            style = "columns";
            row = 4;
            # columns = 2;
          };
        };

        widgets = toYAML "widgets.yaml" [
          {
            resources = {
              cpu = true;
              memory = true;
              disk = "/";
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];
      in [
        "${bookmarks}:/app/config/bookmarks.yaml:ro"
        "${services}:/app/config/services.yaml:ro"
        "${settings}:/app/config/settings.yaml:ro"
        "${widgets}:/app/config/widgets.yaml:ro"
      ];
    };
  };
}
