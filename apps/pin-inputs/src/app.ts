import { readFileSync, writeFileSync } from 'fs';

export const replaceInFile = (replace: RegExp, replacement: string, file: string) => {
    const fileContents = readFileSync(file);

    const replaced = fileContents.toString().replace(replace, replacement);

    writeFileSync(file, replaced);
};

/* Constants */
const FLAKE = process.env.FLAKE;

if (!FLAKE) {
    console.error('Environment variable FLAKE not found');
    process.exit(1);
}

const FLAKE_LOCK = JSON.parse(readFileSync(`${FLAKE}/flake.lock`, 'utf8')).nodes;
const INPUT_REVS = new Map<string, string>();

Object.entries(FLAKE_LOCK).forEach(([key, val]) => {
    if (key !== 'root') {
        // eslint-disable-next-line
        INPUT_REVS.set(key, (val as any).locked.rev);
    }
});

const INPUTS = process.argv.slice(2);


/**
 * Gets the commit hash of the specified input in this flake.
 *
 * @param input the name of the input
 * @returns the commit hash
 */
const getCurrentRev = (input: string): string => {
    if (!INPUT_REVS.has(input)) {
        throw new Error(`Input ${input} could not be found.`);
    }

    return INPUT_REVS.get(input) as string;
};

INPUTS.forEach((input) => {
    try {
        const inputsFile = `${FLAKE}/inputs/default.nix`;
        const rev = getCurrentRev(input);

        replaceInFile(
            new RegExp(`(\\n[ ]*)${input} =.*\\n.*\\n.*`),
            `$&\n$1  # FIXME: $1  rev = "${rev}";`,
            inputsFile,
        );
    }
    catch (e) {
        console.error((e as Error).message);
    }
});
