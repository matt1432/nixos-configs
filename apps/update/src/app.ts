import { parseArgs } from './lib.ts';
import { updateFirefoxAddons } from '././firefox.ts';
import { updateDocker } from './misc.ts';


const args = parseArgs();

if (args['f'] || args['firefox']) {
    console.log(updateFirefoxAddons());
}

if (args['d'] || args['docker']) {
    console.log(updateDocker());
}

if (args['a'] || args['all']) {
    console.log(updateFirefoxAddons());
    console.log(updateDocker());
}
