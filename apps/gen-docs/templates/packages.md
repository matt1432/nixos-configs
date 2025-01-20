# Packages

This directory contains every derivations for packages exposed by this flake.

## List of my packages found in `self.packages`

| Name | Description |
| ---- | ----------- |
$for(attrs/pairs)$
| `$it.key$` | $it.value.desc/nowrap$ | $it.value.homepage/nowrap$ |
$endfor$
