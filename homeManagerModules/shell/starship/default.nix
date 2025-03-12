{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStrings mkIf;

  cfg = config.programs.bash;
in {
  programs.starship = mkIf cfg.enable {
    enable = true;
    enableBashIntegration = true;

    settings = {
      format = concatStrings [
        "╭╴"
        "[](fg:${cfg.promptColors.firstColor})"
        "[  ](bg:${cfg.promptColors.firstColor} fg:#090c0c)"
        "[](bg:${cfg.promptColors.secondColor} fg:${cfg.promptColors.firstColor})"
        "$username$hostname"
        "[](fg:${cfg.promptColors.secondColor} bg:${cfg.promptColors.thirdColor})"
        "$directory"
        "[](fg:${cfg.promptColors.thirdColor} bg:${cfg.promptColors.fourthColor})"
        "$git_branch"
        "[](fg:${cfg.promptColors.fourthColor})$shlvl$nix_shell"
        "\n╰╴$character"
      ];

      username = {
        show_always = true;
        style_user = "fg:${cfg.promptColors.textColor} bg:${cfg.promptColors.secondColor}";
        style_root = "fg:red bg:${cfg.promptColors.secondColor} blink";
        format = "[ $user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "fg:${cfg.promptColors.textColor} bg:${cfg.promptColors.secondColor}";
        format = "[@$hostname ]($style)";
      };

      directory = {
        style = "fg:${cfg.promptColors.firstColor} bg:${cfg.promptColors.thirdColor}";
        format = "[ $path ]($style)";
        truncate_to_repo = false;
        truncation_length = 0;

        substitutions = {
          "Documents" = "󰈙";
          "Downloads" = "";
          "Music" = "";
          "Pictures" = "";
        };
      };

      git_branch = {
        style = "fg:${cfg.promptColors.secondColor} bg:${cfg.promptColors.fourthColor}";
        symbol = "";
        format = "[ $symbol $branch ]($style)";
      };

      shlvl = {
        disabled = false;
        threshold = 2;

        symbol = " 󰔳";
        format = "[$symbol]($style)";

        repeat = true;
        repeat_offset = 1;
      };

      nix_shell = {
        symbol = "❄️ ";
        format = "[ $symbol]($style)";
      };

      character = {
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
    };
  };
}
