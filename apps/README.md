# Apps

This directory contains every derivations for apps exposed by this flake.

## List of my apps found in `self.apps`

| Name | Description |
| ---- | ----------- |
| `extract-subs` | Extract all `srt` subtitle files from a `mkv` video with the appropriate name. FIXME: fluent-ffmpeg is deprecated |
| `gen-docs` | Generates the READMEs in this repository from nix attributes. |
| `list2series` | Converts a Komga read list into a comics series for reading with mihon. |
| `mc-mods` | Checks if a list of mods have a version available for a specific Minecraft version and a specific loader. |
| `pin-inputs` | Takes a list of inputs to pin to their current rev in `flake.lock`. |
| `update-sources` | Updates all derivation sources in this repository and generates a commit message for the changes made. |
