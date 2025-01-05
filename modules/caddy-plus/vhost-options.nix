cfg: {lib, ...}: let
  inherit (lib) literalExpression mkOption types;
in {
  options = {
    reverseProxy = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Option to give the parameters to a simple "reverse_proxy" command
        appended after extraConfig.
      '';
    };

    subDomains = mkOption {
      type = types.attrsOf (types.submodule (import ./sub-domain-options.nix cfg));
      default = {};
      example = literalExpression ''
        {
          headscale = {
            reverseProxy = "localhost:8080";
            extraConfig = '''
              encode gzip
            ''';
          }
        };
      '';
      description = ''
        Declarative specification of a virtual hosts subdomain served by Caddy.
      '';
    };

    subDirectories = mkOption {
      type = types.attrsOf (types.submodule (import ./sub-dir-options.nix cfg));
      default = {};
      example = literalExpression ''
        {
          headscale = {
            appSupport = false;
            reverseProxy = "localhost:8080";
            extraConfig = '''
              encode gzip
            ''';
          };
        };
      '';
      description = ''
        Declarative specification of a subdomain's subdirectories served by Caddy.
      '';
    };
  };
}
