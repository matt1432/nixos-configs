import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';
import { styleText } from 'node:util';

import { parseArgs } from './lib';

import updateCaddyPlugins from './caddy';
import updateDocker from './docker';
import updateFirefoxAddons from '././firefox';
import updateFlakeInputs from './flake';
import runNixUpdate from './nix-update';
import updateNodeModules from './node-modules';
import updateVuetorrent from './vuetorrent';


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
        console.log(updateCaddyPlugins() ?? '');
    }

    if (args['d'] || args['docker']) {
        console.log(updateDocker() ?? '');
    }

    if (args['f'] || args['firefox']) {
        console.log(updateFirefoxAddons() ?? '');
    }

    if (args['h'] || args['homepage']) {
        console.log(runNixUpdate('homepage'));
    }

    if (args['i'] || args['inputs']) {
        console.log(updateFlakeInputs() ?? '');
    }

    if (args['j'] || args['jmusicbot']) {
        console.log(runNixUpdate('jmusicbot'));
    }

    if (args['m'] || args['material-rounded-theme']) {
        console.log(runNixUpdate('scopedPackages', 'lovelace-components', 'material-rounded-theme'));
    }

    if (args['n'] || args['node_modules']) {
        console.log((await updateNodeModules()) ?? '');
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
        console.log(updateVuetorrent() ?? '');
    }

    if (args['a'] || args['all']) {
        // Update this first because of nix run cmd
        const firefoxOutput = updateFirefoxAddons();

        console.log(firefoxOutput ?? 'No updates');


        const flakeOutput = updateFlakeInputs();

        console.log(flakeOutput ?? 'No updates');


        const dockerOutput = updateDocker();

        console.log(dockerOutput ?? 'No updates');


        const nodeModulesOutput = await updateNodeModules();

        console.log(nodeModulesOutput ?? 'No updates');


        const vuetorrentOutput = updateVuetorrent();

        console.log(vuetorrentOutput ?? 'No updates');


        const caddyPluginsOutput = updateCaddyPlugins();

        console.log(caddyPluginsOutput ?? 'No updates');


        // nix-update executions
        const nixUpdateOutputs: string[] = [];

        const updatePackage = (
            attr: string,
            scope?: string,
            scopeAttr?: string,
        ): void => {
            const execution = runNixUpdate(attr, scope, scopeAttr);

            if (execution.changelog) {
                nixUpdateOutputs.push(execution.changelog);
            }
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


        spawnSync('alejandra', ['-q', FLAKE], { shell: true });

        spawnSync('nixFastBuild', [], {
            shell: true,
            stdio: [process.stdin, process.stdout, process.stderr],
        });

        const indentOutput = (output: string): string => {
            return `    ${output.replace(/\n*$/g, '').split('\n').join('\n    ')}`;
        };

        const output = [
            'chore: update sources',
        ];

        if (flakeOutput) {
            output.push(`Flake Inputs:\n${indentOutput(flakeOutput)}\n`);
        }
        if (dockerOutput) {
            output.push(`Docker Images:\n${indentOutput(dockerOutput)}\n`);
        }
        if (firefoxOutput) {
            output.push(`Firefox Addons:\n${indentOutput(firefoxOutput)}\n`);
        }
        if (nodeModulesOutput) {
            output.push(`Node modules:\n${indentOutput(nodeModulesOutput)}\n`);
        }
        if (vuetorrentOutput) {
            output.push(`qBittorrent Sources:\n${indentOutput(vuetorrentOutput)}\n`);
        }
        if (caddyPluginsOutput) {
            output.push(`Caddy Plugins:\n${indentOutput(caddyPluginsOutput)}\n`);
        }
        if (nixUpdateOutputs.length > 0) {
            output.push(`nix-update executions:\n${indentOutput(nixUpdateOutputs.join('\n'))}\n`);
        }

        if (args['f']) {
            console.log(styleText(['magenta'], `\n\nWriting commit message to ${args['f']}\n`));
            writeFileSync(args['f'], output.join('\n\n'));
        }
        else {
            console.log(styleText(['magenta'], '\n\nCommit message:\n'));
            console.log(output.join('\n\n'));
        }
    }
};

main();
