import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';

import { parseArgs } from './lib.ts';
import { updateFirefoxAddons } from '././firefox.ts';
import { updateDocker, updateFlakeInputs, updateVuetorrent } from './misc.ts';


/* Constants */
const FLAKE = process.env.FLAKE;

if (!FLAKE) {
    console.error('Env var FLAKE not found');
    process.exit(1);
}

const args = parseArgs();

if (args['d'] || args['docker']) {
    console.log(updateDocker());
}

if (args['i'] || args['inputs']) {
    console.log(updateFlakeInputs());
}

if (args['f'] || args['firefox']) {
    console.log(updateFirefoxAddons());
}

if (args['v'] || args['vuetorrent']) {
    console.log(updateVuetorrent());
}

if (args['a'] || args['all']) {
    // Update this first because of nix run cmd
    const firefoxOutput = updateFirefoxAddons();

    console.log(firefoxOutput);


    const flakeOutput = updateFlakeInputs();

    console.log(flakeOutput);


    const dockerOutput = updateDocker();

    console.log(dockerOutput);


    const vuetorrentOutput = updateVuetorrent();

    console.log(vuetorrentOutput);


    spawnSync('nix-fast-build', ['-f', `${FLAKE}#nixFastChecks`], {
        shell: true,
        stdio: [process.stdin, process.stdout, process.stderr],
    });

    const output = [
        'chore: update flake.lock',
        `Flake Inputs:\n${flakeOutput}`,
        `Docker Images:\n${dockerOutput}`,
        `Firefox Addons:\n${firefoxOutput}`,
        `Misc Sources:\n${vuetorrentOutput}`,
    ].join('\n\n');

    if (args['f']) {
        writeFileSync(args['f'] as string, output);
    }
    else {
        console.log(output);
    }
}

spawnSync('alejandra', ['-q', FLAKE], { shell: true });
