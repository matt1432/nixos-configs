import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

const updateImages = (imagePath: string): string | undefined => {
    console.log(`Updating ${imagePath.split('/').at(-1)} images`);

    const out = spawnSync('updateImages', [imagePath], { shell: true }).stdout.toString();

    if (out.length > 1) {
        return out;
    }
};

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating docker images:\n'));

    const updates: string[] = [];

    const jdownloaderUpdates = updateImages(`${FLAKE}/configurations/nos/modules/comics/jdownloader2`);

    if (jdownloaderUpdates) {
        updates.push(jdownloaderUpdates);
    }

    const jellfyinUpdates = updateImages(`${FLAKE}/configurations/nos/modules/jellyfin`);

    if (jellfyinUpdates) {
        updates.push(jellfyinUpdates);
    }

    const hassUpdates = updateImages(`${FLAKE}/configurations/homie/modules/home-assistant/netdaemon`);

    if (hassUpdates) {
        updates.push(hassUpdates);
    }

    const DIR = `${FLAKE}/configurations/nos/modules/docker`;

    readdirSync(DIR, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            const composeUpdates = updateImages(path.parentPath);

            if (composeUpdates) {
                updates.push(composeUpdates);
            }
        }
    });

    return updates.length > 0 ?
        updates.join('') :
        null;
};
