import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';

import { parseArgs } from './lib.ts';
import { updateFirefoxAddons } from '././firefox.ts';

import {
    updateCustomSidebarDeps,
    updateDocker,
    updateFlakeInputs,
    updateVuetorrent,
} from './misc.ts';


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

if (args['c'] || args['custom-sidebar']) {
    console.log(updateCustomSidebarDeps());
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

    // This doesn't need to be added to commit msgs
    console.log(updateCustomSidebarDeps());


    spawnSync('nix-fast-build', ['-f', `${FLAKE}#nixFastChecks`], {
        shell: true,
        stdio: [process.stdin, process.stdout, process.stderr],
    });

    const output = [
        'chore: update flake.lock\n',
        `Flake Inputs:\n${flakeOutput}\n`,
        `Docker Images:\n${dockerOutput}`,
        `Firefox Addons:\n${firefoxOutput}\n`,
        `Misc Sources:\n${vuetorrentOutput}\n`,
    ].join('\n');

    if (args['f']) {
        writeFileSync(args['f'] as string, output);
    }
    else {
        console.log(output);
    }
}

spawnSync('alejandra', ['-q', FLAKE], { shell: true });
