import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating flake inputs:\n'));

    const output: string = spawnSync(
        `git restore flake.lock &> /dev/null; nix flake update --flake ${FLAKE}` +
        ' |& grep -v "warning: updating lock file" |& grep -v "unpacking"',
        [],
        { shell: true },
    ).stdout.toString();

    const inputsUpdates: string[] = output
        // Get an array of each update / change
        .split('\n•')
        // Filter out some inputs
        .filter((input) => ![
            'systems',
            'flake-compat',
            'flake-utils',
            'flake-parts',
            'treefmt-nix',
            'lib-aggregate',
            'lib-aggregate/nixpkgs-lib',
            'nix-gaming/umu',
            'nix-github-actions',
            'pre-commit-hooks',
            'pre-commit-hooks/nixpkgs',
        ].some((inputName) => input.startsWith(` Updated input '${inputName}'`)));

    const formattedOutput: string = inputsUpdates
        // Add an extra blank line between inputs
        .join('\n\n•')
        // Help readability of git revs
        .split('\n')
        .map((l) => l
            .replace(
                /\/(.{40})\?narHash=sha256[^']*(.*)/,
                (_, backref1, backref2) => `${backref2} rev: ${backref1}`,
            )
            .replace(
                /\?ref.*&rev=(.{40})[^'&]*(.*)/,
                (_, backref1, backref2) => `${backref2} rev: ${backref1}`,
            ))
        .join('\n');

    // make sure we cleanup 'follows' statements
    spawnSync('just genflake', [], {
        cwd: FLAKE, shell: true, stdio: 'inherit',
    });

    return inputsUpdates.length > 0 ?
        formattedOutput :
        null;
};
