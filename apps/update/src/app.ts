import { parseArgs } from './lib.ts';
import { updateFirefoxAddons } from '././firefox.ts';
import { updateDocker, updateVuetorrent } from './misc.ts';


const args = parseArgs();

if (args['d'] || args['docker']) {
    console.log(updateDocker());
}

if (args['f'] || args['firefox']) {
    console.log(updateFirefoxAddons());
}

if (args['v'] || args['vuetorrent']) {
    console.log(updateVuetorrent());
}

if (args['a'] || args['all']) {
    console.log(updateVuetorrent());
    console.log(updateFirefoxAddons());
    console.log(updateDocker());
}
