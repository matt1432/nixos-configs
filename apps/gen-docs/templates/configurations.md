# nixosConfigurations

This directory contains every device's main configuration file, their `hardware-configuration.nix` and some custom modules
unique to them.

## List of my Devices

| Name      | Model / Specs | Description                                                                                      |
| --------- | ------------- | ------------------------------------------------------------------------------------------------ |
| `android` | OnePlus 9 Pro | [Nix-On-Droid](https://github.com/nix-community/nix-on-droid) configuration for my OnePlus 9 Pro |
$for(attrs/pairs)$
| `$it.key$` | $it.value.hwDesc/nowrap$ | $it.value.roleDesc/nowrap$ |
$endfor$
