import { spawnSync } from 'node:child_process';


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
            'lib-aggregate/nixpkgs-lib',
            'sops-nix/nixpkgs-stable',
        ].some((inputName) => input.startsWith(` Updated input '${inputName}'`)))
        .join('\n\n•')
        // Shorten git revs to help readability
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

    return output;
};
