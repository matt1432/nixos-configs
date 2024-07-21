import { parseArgs } from './lib.ts';
import { updateFirefoxAddons } from '././firefox.ts';


const args = parseArgs();

if (args['f'] || args['firefox']) {
    console.log(updateFirefoxAddons());
}
