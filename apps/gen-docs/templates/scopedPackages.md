# ScopedPackages

This directory contains every package scopes exposed by this flake.

## List of my package scopes found in `self.scopedPackages`

$for(attrs/pairs)$
### $it.key$

$it.value.desc/nowrap$

| Name | Description | Homepage |
| ---- | ----------- | -------- |
$for(it.value.packages/pairs)$
| `$it.key$` | $it.value.desc/nowrap$ | $it.value.homepage/nowrap$ |
$endfor$

$endfor$
