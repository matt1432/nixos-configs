import { readdirSync, writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

import { parseFetchurl } from './lib.ts';


/* Constants */
const FLAKE = process.env.FLAKE;

export const updateFlakeInputs = () => {
    const output = spawnSync(
        `nix flake update --flake ${FLAKE} |& grep -v "warning: updating lock file"`,
        [],
        { shell: true },
    ).stdout
        .toString()
        // Add an extra blank line between inputs
        .split('\n•')
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

    const FILE = `${FLAKE}/devices/nos/modules/docker`;

    readdirSync(FILE, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            updates += spawnSync('updateImages', [path.parentPath], { shell: true })
                .stdout.toString();
        }
    });

    return updates;
};

const genVueText = (version: string, hash: string, url: string) =>
    `# This file was autogenerated. DO NOT EDIT!
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
