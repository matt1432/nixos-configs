import { writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

import { replaceInFile } from './lib';

/* Types */
interface Plugin {
    url: string
    version: string
    type: 'version' | 'git'
}


/* Constants */
const FLAKE = process.env.FLAKE;

const genPluginsText = (
    plugins: Record<string, Plugin>,
) => `{
  plugins = {
${Object.entries(plugins)
    .map(([key, value]) => `
    ${key} = {
      url = "${value.url}";
      version = "${value.version}";
      type = "${value.type}";
    };
    `)
    .join('')}
  };

  hash = "";
}
`;

export const updateCaddyPlugins = () => {
    let updates = '';
    const dir = `${FLAKE}/configurations/cluster/modules/caddy`;

    // Setup workspace
    spawnSync(
        [
            'rm -rf /tmp/update-caddy',
            'mkdir -p /tmp/update-caddy',
            'cd /tmp/update-caddy || exit 1',
            'go mod init temp',
        ].join('; '),
        [],
        { shell: true, cwd: '/tmp' },
    );

    const plugins = JSON.parse(spawnSync('nix',
        ['eval', '-f', `${dir}/plugins.nix`, '--json'],
        { shell: true }).stdout.toString()).plugins as Record<string, Plugin>;

    // Get most recent versions of plugins
    Object.entries(plugins).forEach(([key, value]) => {
        const NEW_VERSION = spawnSync([
            'go mod init temp > /dev/null',
            `go get ${value.url}${value.type === 'git' ? '@HEAD' : ''} > /dev/null`,
            `grep '${value.url}' go.mod`,
        ].join('; '), [], { shell: true, cwd: '/tmp/update-caddy' })
            .stdout
            .toString()
            .trim()
            .replace(' // indirect', '')
            .split(' ')[1];

        if (plugins[key].version !== NEW_VERSION) {
            updates += `${key}: ${plugins[key].version} -> ${NEW_VERSION}\n`;
            plugins[key].version = NEW_VERSION;
        }
    });

    writeFileSync(`${dir}/plugins.nix`, genPluginsText(plugins));

    // Get new hash
    const caddyPkgAttr = 'nixosConfigurations.thingone.config.services.caddy.package';

    const NEW_HASH = spawnSync(
        `nix build "$FLAKE#${caddyPkgAttr}" |& sed -n 's/.*got: *//p'`,
        [],
        { shell: true },
    ).stdout.toString().trim();

    replaceInFile(/hash = ".*";/, `hash = "${NEW_HASH}";`, `${dir}/plugins.nix`);

    return updates;
};
