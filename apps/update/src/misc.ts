import { readdirSync, writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

import { parseFetchurl } from './lib.ts';


/* Constants */
const FLAKE = process.env.FLAKE;

export const updateFlakeInputs = () => {
    const output = spawnSync(
        `git restore flake.lock &> /dev/null; nix flake update --flake ${FLAKE}` +
        ' |& grep -v "warning: updating lock file" |& grep -v "unpacking"',
        [],
        { shell: true },
    ).stdout
        .toString()
        // Add an extra blank line between inputs
        .split('\n•')
        .filter((input) => ![
            'systems',
            'flake-utils',
            'flake-parts',
            'treefmt-nix',
            'lib-aggregate',
        ].some((inputName) => input.startsWith(` Updated input '${inputName}'`)))
        .join('\n\n•')
        // Shorten git revs to help readability
        .split('\n')
        .map((l) => l
            .replace(/.{33}\?narHash=sha256[^']*/, '')
            .replace(/&rev=(.{7})[^'&]*/, (_, backref) => `&rev=${backref}`))
        .join('\n');

    return output;
};

export const updateDocker = () => {
    let updates = '';

    console.log('Updating jfa-go image');
    updates += spawnSync('updateImages',
        [`${FLAKE}/devices/nos/modules/jellyfin`],
        { shell: true })
        .stdout.toString();

    console.log('Updating netdaemon image');
    updates += spawnSync('updateImages',
        [`${FLAKE}/devices/homie/modules/home-assistant/netdaemon`],
        { shell: true })
        .stdout.toString();

    const FILE = `${FLAKE}/devices/nos/modules/docker`;

    readdirSync(FILE, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            console.log(`Updating ${path.parentPath.split('/').at(-1)} images`);
            updates += spawnSync('updateImages', [path.parentPath], { shell: true })
                .stdout.toString();
        }
    });

    return updates;
};

const genVueText = (
    version: string,
    hash: string,
    url: string,
) => `# This file was autogenerated. DO NOT EDIT!
{
  version = "${version}";
  url = "${url}";
  hash = "${hash}";
}
`;

export const updateVuetorrent = () => {
    const FILE = `${FLAKE}/devices/nos/modules/qbittorrent/vuetorrent.nix`;

    const OLD_VERSION = JSON.parse(spawnSync('nix',
        ['eval', '-f', FILE, '--json'],
        { shell: true }).stdout.toString()).version;

    const VERSION = JSON.parse(spawnSync('curl',
        ['-s', 'https://api.github.com/repos/VueTorrent/VueTorrent/releases/latest'],
        { shell: true }).stdout.toString()).tag_name.replace('v', '');

    const URL = `https://github.com/VueTorrent/VueTorrent/releases/download/v${VERSION}/vuetorrent.zip`;
    const HASH = parseFetchurl(URL);

    const fileText = genVueText(VERSION, HASH, URL);

    writeFileSync(FILE, fileText);

    return OLD_VERSION !== VERSION ? `Vuetorrent: ${OLD_VERSION} -> ${VERSION}` : '';
};

export const updateCustomPackage = (pkg: string) => spawnSync(
    `nix run ${FLAKE}#${pkg}.update`,
    [],
    { shell: true },
).stderr.toString();
