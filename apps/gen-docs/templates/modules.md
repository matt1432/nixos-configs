# nixosModules

This directory contains every modules for NixOS exposed by this flake.

## List of my modules found in `self.nixosModules`

| Name | Description |
| ---- | ----------- |
$for(attrs/pairs)$
| `$it.key$` | $it.value.desc/nowrap$ |
$endfor$
