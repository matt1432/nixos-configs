const { execAsync, monitorFile } = Utils;


/**
 * @param {string} host the name of the machine/user who's running ags
 */
const watchAndCompileSass = (host) => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/${host}.scss`;
        const css = `/tmp/ags-${host}/style.css`;

        execAsync(`sass ${scss} ${css}`).then(() => {
            App.resetCss();
            App.applyCss(css);
        }).catch(print);
    };

    monitorFile(
        `${App.configDir}/scss`,
        reloadCss,
    );
    reloadCss();
};

/**
 * @param {string} host the name of the machine/user who's running ags
 * @returns the config
 */
export const transpileTypeScript = async(host) => {
    const outPath = `/tmp/ags-${host}/index.js`;

    await execAsync([
        'bash', '-c',
        // Create the dir if it doesn't exist
        `mkdir -p /tmp/ags-${host}; ` +

        // Let bun see tsconfig.json
        `cd ${App.configDir};` +

        `bun build ${App.configDir}/${host === 'lockscreen' ? 'ts/lockscreen/main' : host}.ts ` +
        '--external resource:///* ' +
        '--external gi://* ' +
        '--external cairo ' +

        // Since bun wants to write in cwd, we just redirect stdin instead
        `> ${outPath}`,
    ]).catch(print);

    watchAndCompileSass(host);

    return await import(`file://${outPath}`);
};
