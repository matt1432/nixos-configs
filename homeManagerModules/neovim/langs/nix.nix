self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) getExe hasPrefix mkIf removePrefix;
  inherit (osConfig.networking) hostName;

  cfg = config.programs.neovim;

  defaultFormatter = self.formatter.${pkgs.system};

  nixdPkg = self.inputs.nixd.packages.${pkgs.system}.default;

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
  flakeDir = "${removePrefix "/home/${cfg.user}/" flakeEnv}";
in {
  config = mkIf cfg.enableIde {
    assertions = [
      {
        assertion =
          cfg.enableIde
          && hasPrefix "/home/${cfg.user}/" flakeEnv
          || !cfg.enableIde;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the neovim module.
        '';
      }
    ];

    home.packages = [
      defaultFormatter
      nixdPkg
    ];

    # nixd by default kinda spams LspLog
    home.sessionVariables.NIXD_FLAGS = "-log=error";

    xdg.dataFile."${flakeDir}/.nixd.json".text = builtins.toJSON {
      nixpkgs = {
        expr = "import (builtins.getFlake \"${flakeDir}\").inputs.nixpkgs {}";
      };
      options.nixos = {
        expr = "(builtins.getFlake \"${flakeDir}\").nixosConfigurations.${hostName}.options";
      };
    };

    programs = {
      neovim = {
        extraPackages = [
          nixdPkg
        ];

        extraLuaConfig =
          # lua
          ''
            require('lspconfig').nixd.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),

                filetypes = { 'nix', 'in.nix' },
                settings = {
                    nixd = {
                        formatting = {
                            -- TODO: Try to find <flake>.formatter
                            command = { '${getExe defaultFormatter}' },
                        },
                    },
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./nix.nix;
}
