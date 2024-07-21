import { updateFirefoxAddons } from '././firefox.ts';

/* Parse Args */
const args = {} as Record<string, unknown>;
let lastFlag: string | null = null;

for (let i = 2; i < process.argv.length; ++i) {
    const arg = process.argv[i];

    if (arg.toString().startsWith('-')) {
        lastFlag = arg.toString().replace(/^-{1,2}/, '');
        args[lastFlag] = true;
    }
    else if (lastFlag) {
        args[lastFlag] = arg;
        lastFlag = null;
    }
    else {
        console.error(`Could not parse args: ${arg.toString()}`);
    }
}

/* Exec functions based on args */
if (args['f'] || args['firefox']) {
    console.log(updateFirefoxAddons());
}
