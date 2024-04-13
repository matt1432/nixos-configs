# [AGS](https://github.com/Aylur/ags)

## Nix

This directory is the Nix entrypoint to my AGS configration.

On system activation, if this module is imported, it will
generate the `config.js` of the host with the host's name
as the parameter in `transpileTypeScript` to support a different
setup per device.

## Non-Nix

To use this setup without Nix:

```js
/* ~/.config/ags/config.js */

import { transpileTypeScript } from './js/utils.js';

export default (await transpileTypeScript('wim')).default;
```

If you want to try my main config, this is what you need to have
as your `config.js` after copying the contents of `./config` to
`~/.config/ags`

## Dependencies

The main dependencies to try it are as follows:

- **bun** to transpile TS to JS
- **dart-sass** to compile SCSS to CSS
- **[coloryou](https://git.nelim.org/matt1432/nixos-configs/src/branch/master/common/pkgs/coloryou)** for media player colors
- **playerctl** for media player functionality

If you're interested in my 2-1 laptop setup, you'll need:

- **ydotool** for my custom on-screen keyboard
- **lisgd** to have touch screen gestures
