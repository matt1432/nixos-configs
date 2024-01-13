import { watchAndCompileSass, transpileTypeScript } from 'file:///home/matt/.nix/devices/wim/config/ags/js/utils.js';

watchAndCompileSass();

// Compile wim's config since that is where the big boy code is
// I have it symlinked in the git repo so TS server can see it
await transpileTypeScript(
    '/home/matt/.nix/devices/wim/config/ags',
    '/tmp/ags/wim',
);
export default (await import(await transpileTypeScript())).default;
