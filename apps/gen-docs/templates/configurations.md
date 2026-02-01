# NixosConfigurations

This directory contains every device's main configuration file, their `hardware-configuration.nix` and some custom modules
unique to them.

## List of my devices

| Name      | Model / Specs | Description                                                                                      |
| --------- | ------------- | ------------------------------------------------------------------------------------------------ |
$for(attrs/pairs)$
| `$it.key$` | $it.value.hwDesc/nowrap$ | $it.value.roleDesc/nowrap$ |
$endfor$
