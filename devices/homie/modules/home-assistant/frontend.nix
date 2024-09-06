{dracul-ha-src, ...}: {
  services.home-assistant = {
    config = {
      # GUI
      frontend = {
        themes = "!include ${dracul-ha-src}/themes/dracul-ha.yaml";
      };
      lovelace = {
        mode = "yaml";
      };
    };
  };
}
