import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';

import { parseArgs } from './lib';

import { updateDocker } from './docker';
import { updateFirefoxAddons } from '././firefox';
import { updateFlakeInputs } from './flake';
import { updateCustomPackage, updateVuetorrent } from './misc';


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
    console.log(updateCustomPackage('scopedPackages.x86_64-linux.lovelace-components.custom-sidebar'));
}

if (args['s'] || args['some-sass-language-server']) {
    console.log(updateCustomPackage('some-sass-language-server'));
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
    console.log(updateCustomPackage('scopedPackages.x86_64-linux.lovelace-components.custom-sidebar'));
    console.log(updateCustomPackage('some-sass-language-server'));


    spawnSync('nix-fast-build', ['-f', `${FLAKE}#nixFastChecks`], {
        shell: true,
        stdio: [process.stdin, process.stdout, process.stderr],
    });

    const output = [
        'chore: update sources\n\n',
    ];

    if (flakeOutput.length > 5) {
        output.push(`Flake Inputs:\n${flakeOutput}\n\n`);
    }
    if (dockerOutput.length > 5) {
        output.push(`Docker Images:\n${dockerOutput}\n`);
    }
    if (firefoxOutput.length > 5) {
        output.push(`Firefox Addons:\n${firefoxOutput}\n\n`);
    }
    if (vuetorrentOutput.length > 5) {
        output.push(`Misc Sources:\n${vuetorrentOutput}\n`);
    }

    if (args['f']) {
        writeFileSync(args['f'] as string, output.join(''));
    }
    else {
        console.log(output.join(''));
    }
}

spawnSync('alejandra', ['-q', FLAKE], { shell: true });
