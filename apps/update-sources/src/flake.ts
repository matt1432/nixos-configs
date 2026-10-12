import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';

/* Constants */
const FLAKE = process.env.FLAKE;

const hasUpdated = (input: string) => {
    const parts = input.split('\n');

    return !parts[2].includes(parts[1].trim());
};

const isWantedInput = (input: string) => {
    return ![
        'systems',
        'flake-compat',
        'flake-utils',
        'flake-parts',
        'treefmt-nix',
        'lib-aggregate',
        'lib-aggregate/nixpkgs-lib',
        'nix-github-actions',
        'pre-commit-hooks',
        'pre-commit-hooks/nixpkgs',
    ].some((inputName) => input.startsWith(` Updated input '${inputName}'`));
};

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating flake inputs:\n'));

    const output: string = spawnSync(
        `git restore flake.lock &> /dev/null; nix flake update --flake ${FLAKE}` +
            ' |& grep -v "warning: updating lock file"' +
            ' |& grep -v "unpacking"' +
            ' |& grep -v "fetching"' +
            ' |& grep -v "has an override for a non-existent input "' + // We fix that at the end
            '',
        [],
        { shell: true },
    ).stdout.toString();

    const inputsUpdates: string[] = output
        .split('\n•') // Each input starts with '•'
        .filter(
            (input) =>
                input.startsWith(' Updated input ') &&
                isWantedInput(input) &&
                hasUpdated(input),
        );

    const formattedOutput: string = inputsUpdates
        // Add an extra blank line between inputs
        .join('\n\n•')
        // Help readability of git revs
        .split('\n')
        .map((l) =>
            l
                .replace(
                    /\/(.{40})\?narHash=sha256[^']*(.*)/,
                    (_, backref1, backref2) => `${backref2} rev: ${backref1}`,
                )
                .replace(
                    /(\?ref.*)&rev=(.{40})[^'&]*(.*)/,
                    (_, b1, b2, b3) => `${b1}${b3} rev: ${b2}`,
                )
                .replace(
                    /'github:(.*)\/([^/]*)'(.*)/,
                    (_, b1, b2, b3) => `'github:${b1}'${b3} rev: ${b2}`,
                ),
        )
        .join('\n');

    // make sure we cleanup 'follows' statements
    spawnSync('just genflake', [], {
        cwd: FLAKE,
        shell: true,
        stdio: 'inherit',
    });

    return inputsUpdates.length > 0 ? '•' + formattedOutput : null;
};
