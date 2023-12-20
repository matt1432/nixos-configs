{...}: {
  services = {
    blocky = {
      enable = true;
      settings = {
        upstream = {
          default = [
            "127.0.0.1:5335"
            "127.0.0.1:5335"
          ];
        };

        blocking = {
          blackLists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
          };
        };
      };
    };
  };
}
