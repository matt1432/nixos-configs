import { writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';

import { parseFetchurl } from './lib';


/* Constants */
const FLAKE = process.env.FLAKE;

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

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating Vuetorrent:\n'));

    const FILE = `${FLAKE}/configurations/nos/modules/qbittorrent/vuetorrent.nix`;

    const OLD_VERSION = JSON.parse(spawnSync(
        ['nix', 'eval', '-f', FILE, '--json'].join(' '), [], { shell: true },
    ).stdout.toString()).version;

    const VERSION = JSON.parse(spawnSync(
        ['curl', '-s', 'https://api.github.com/repos/VueTorrent/VueTorrent/releases/latest'].join(' '), [], { shell: true },
    ).stdout.toString()).tag_name.replace('v', '');

    const URL = `https://github.com/VueTorrent/VueTorrent/releases/download/v${VERSION}/vuetorrent.zip`;
    const HASH = parseFetchurl(URL);

    const fileText = genVueText(VERSION, HASH, URL);

    writeFileSync(FILE, fileText);

    return OLD_VERSION !== VERSION ? `Vuetorrent: ${OLD_VERSION} -> ${VERSION}\n` : null;
};
