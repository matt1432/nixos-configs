import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';

import { parseArgs } from './lib';

import { updateCaddyPlugins } from './caddy';
import { updateDocker } from './docker';
import { updateFirefoxAddons } from '././firefox';
import { updateFlakeInputs } from './flake';
import updateNodeModules from './node-modules';

import {
    runNixUpdate,
    updateVuetorrent,
} from './misc';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

if (!FLAKE) {
    console.error('Env var FLAKE not found');
    process.exit(1);
}

const args = parseArgs();

const main = async() => {
    if (args['c'] || args['custom-sidebar']) {
        console.log(runNixUpdate('scopedPackages', 'lovelace-components', 'custom-sidebar'));
    }

    if (args['cp'] || args['caddy-plugins']) {
        console.log(updateCaddyPlugins());
    }

    if (args['d'] || args['docker']) {
        console.log(updateDocker());
    }

    if (args['f'] || args['firefox']) {
        console.log(updateFirefoxAddons());
    }

    if (args['h'] || args['homepage']) {
        console.log(runNixUpdate('homepage'));
    }

    if (args['i'] || args['inputs']) {
        console.log(updateFlakeInputs());
    }

    if (args['j'] || args['jmusicbot']) {
        console.log(runNixUpdate('jmusicbot'));
    }

    if (args['m'] || args['material-rounded-theme']) {
        console.log(runNixUpdate('scopedPackages', 'lovelace-components', 'material-rounded-theme'));
    }

    if (args['n'] || args['node_modules']) {
        console.log(await updateNodeModules());
    }

    if (args['p'] || args['pam-fprint-grosshack']) {
        console.log(runNixUpdate('pam-fprint-grosshack'));
    }

    if (args['ph'] || args['protonhax']) {
        console.log(runNixUpdate('protonhax'));
    }

    if (args['s'] || args['some-sass-language-server']) {
        console.log(runNixUpdate('some-sass-language-server'));
    }

    if (args['t'] || args['trash-d']) {
        console.log(runNixUpdate('trash-d'));
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


        const nodeModulesOutput = await updateNodeModules();

        console.log(nodeModulesOutput);


        const vuetorrentOutput = updateVuetorrent();

        console.log(vuetorrentOutput);


        const caddyPluginsOutput = updateCaddyPlugins();

        console.log(caddyPluginsOutput);


        // nix-update executions
        let nixUpdateOutputs = '';

        const updatePackage = (
            attr: string,
            scope?: string,
            scopeAttr?: string,
        ): void => {
            const execution = runNixUpdate(attr, scope, scopeAttr);

            nixUpdateOutputs += execution.stdout;
            console.log(execution.stderr);
            console.log(execution.stdout);
        };

        updatePackage('homepage');
        updatePackage('jmusicbot');
        updatePackage('pam-fprint-grosshack');
        updatePackage('protonhax');
        updatePackage('some-sass-language-server');
        updatePackage('trash-d');
        updatePackage('scopedPackages', 'lovelace-components', 'custom-sidebar');
        updatePackage('scopedPackages', 'lovelace-components', 'material-rounded-theme');


        spawnSync('nixFastBuild', [], {
            shell: true,
            stdio: [process.stdin, process.stdout, process.stderr],
        });

        const indentOutput = (output: string): string => {
            return `    ${output.replace(/\n*$/g, '').split('\n').join('\n    ')}`;
        };

        const output = [
            'chore: update sources\n\n',
        ];

        if (flakeOutput.length > 5) {
            output.push(`Flake Inputs:\n${indentOutput(flakeOutput)}\n\n\n`);
        }
        if (dockerOutput.length > 5) {
            output.push(`Docker Images:\n${indentOutput(dockerOutput)}\n\n\n`);
        }
        if (firefoxOutput.length > 5) {
            output.push(`Firefox Addons:\n${indentOutput(firefoxOutput)}\n\n\n`);
        }
        if (nodeModulesOutput.length > 5) {
            output.push(`Node modules:\n${indentOutput(nodeModulesOutput)}\n\n\n`);
        }
        if (vuetorrentOutput.length > 5) {
            output.push(`Misc Sources:\n${indentOutput(vuetorrentOutput)}\n\n\n`);
        }
        if (caddyPluginsOutput.length > 5) {
            output.push(`Caddy Plugins:\n${indentOutput(caddyPluginsOutput)}\n\n\n`);
        }
        if (nixUpdateOutputs.length > 5) {
            output.push(`nix-update executions:\n${indentOutput(nixUpdateOutputs)}\n\n\n`);
        }

        if (args['f']) {
            writeFileSync(args['f'] as string, output.join(''));
        }
        else {
            console.log(styleText(['magenta'], '\n\nCommit message:\n'));
            console.log(output.join(''));
        }
    }

    spawnSync('alejandra', ['-q', FLAKE], { shell: true });
};

main();
