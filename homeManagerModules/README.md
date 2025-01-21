# homeManagerModules

This directory contains every home-manager modules exposed by this flake.

## List of my home-manager modules found in `self.homeManagerModules`

| Name | Description |
| ---- | ----------- |
| `firefox` | Uses the home-manager firefox module to declare my custom configuration which includes my list of extensions, my adapted [firefox-gx](https://github.com/Godiesc/firefox-gx) theme and other settings. |
| `neovim` | Uses the home-manager neovim module to declare my custom configuration and expands it with toggles for certain LSPs. This configuration loads corresponding devShells of the current language from `self.devShells` dynamically to support various LSPs. |
| `shell` | Extends the bash home-manager options to set some bash options, aliases themes that follow Dracula Theme and settings for CLI programs, such as starship, trash-d, nix-comma, nix-direnv, git, etc. |
