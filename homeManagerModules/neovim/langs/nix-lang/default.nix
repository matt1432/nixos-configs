self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) getExe hasPrefix mkIf;
  inherit (osConfig.networking) hostName;

  cfg = config.programs.neovim;
  mainHmCfg = osConfig.home-manager.users.${cfg.user} or config;

  defaultFormatter = self.formatter.${pkgs.stdenv.hostPlatform.system};
  formatCmd = pkgs.writeShellApplication {
    name = "nix-fmt-cmd";
    runtimeInputs = with pkgs; [jq];
    text = ''
      if info="$(nix flake show --json 2> /dev/null)" && [[ "$(jq -r .formatter <<< "$info")" != "null" ]]; then
          exec nix fmt -- --
      else
          exec ${getExe defaultFormatter}
      fi
    '';
  };

  # FIXME: https://github.com/nix-community/nixd/issues/799
  generateSplicesForNixComponents = nixComponentsAttributeName:
    pkgs.generateSplicesForMkScope [
      "nixVersions"
      nixComponentsAttributeName
    ];
  nixComponents =
    (pkgs.nixDependencies.callPackage "${pkgs.path}/pkgs/tools/package-management/nix/modular/packages.nix" rec {
      version = "2.33.3";
      inherit (pkgs.nixVersions.nix_2_31.meta) teams;
      otherSplices = generateSplicesForNixComponents "nixComponents_2_33";
      src = pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nix";
        tag = version;
        hash = "sha256-2Mga4e9ZtOPLwYqF4+hcjdsTImcA7TKUvDDfaF7jqEo=";
      };
    }).appendPatches [
      (pkgs.fetchpatch {
        name = "nix-lowdown-3.0-support.patch";
        url = "https://github.com/NixOS/nix/commit/472c35c561bd9e8db1465e0677f1efe2cb88c568.patch";
        hash = "sha256-ZCQgI/euBN8t9rgdCsGRgrcEWG3T5MUc+bQc4tIcHuI=";
      })
    ];

  nixdPkg = pkgs.nixd.override (o: {
    inherit nixComponents;
    nixf = o.nixf.override {inherit (nixComponents) nix-expr;};
    nixt = o.nixt.override {inherit nixComponents;};
  });

  flakeEnv = config.programs.bash.sessionVariables.FLAKE;

  getFlake = "(builtins.getFlake \"${flakeEnv}\")";

  optionsAttr =
    if osConfig != null
    then "nixosConfigurations.${hostName}.options"
    else "nixOnDroidConfigurations.default.options";

  homeOptionsAttr =
    if osConfig != null
    then "${optionsAttr}.home-manager.users.type.getSubOptions []"
    else "${optionsAttr}.home-manager";
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableNix) {
    assertions = [
      {
        assertion = hasPrefix "${mainHmCfg.home.homeDirectory}/" flakeEnv;
        message = ''
          Your $FLAKE environment variable needs to point to a directory in
          the main users' home to use the neovim module.
        '';
      }
    ];

    # We keep the packages here
    home.packages = attrValues {
      inherit
        defaultFormatter
        nixdPkg
        ;
    };

    # nixd by default kinda spams LspLog
    home.sessionVariables.NIXD_FLAGS = "-log=error";

    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit nixdPkg;
        };

        initLua =
          # lua
          ''
            vim.lsp.enable("nixd")
            vim.lsp.config("nixd", {
                capabilities = require("cmp_nvim_lsp").default_capabilities(),

                filetypes = { "nix", "in.nix" },
                settings = {
                    nixd = {
                        nixpkgs = {
                            expr = "import ${getFlake}.inputs.nixpkgs {}",
                        },
                        formatting = {
                            command = { "${getExe formatCmd}" },
                        },
                        options = {
                            nixos = {
                                expr = "${getFlake}.${optionsAttr}",
                            },
                            home_manager = {
                                expr = "${getFlake}.${homeOptionsAttr}",
                            },
                        },
                    },
                },
            })

            require("conform").formatters_by_ft.nix = { "mynixfmt", "injected" }

            require("conform").formatters.mynixfmt = {
                command = "${getExe formatCmd}",
            }

            -- Customize the "injected" formatter for otter-ls
            require("conform").formatters.injected = {
                options = {
                    ignore_errors = false,

                    -- Map of treesitter language to file extension
                    -- A temporary file name with this extension will be generated during formatting
                    -- because some formatters care about the filename.
                    lang_to_ext = {
                        bash = "sh",
                        c_sharp = "cs",
                        elixir = "exs",
                        javascript = "js",
                        julia = "jl",
                        latex = "tex",
                        lua = "lua",
                        markdown = "md",
                        python = "py",
                        ruby = "rb",
                        rust = "rs",
                        teal = "tl",
                        r = "r",
                        typescript = "ts",
                    },

                    -- Map of treesitter language to formatters to use
                    -- (defaults to the value from formatters_by_ft)
                    lang_to_formatters = {},
                },
            }
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
