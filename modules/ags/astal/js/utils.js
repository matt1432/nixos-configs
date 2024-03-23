const { execAsync, monitorFile } = Utils;


/** @param {string} host */
const watchAndCompileSass = (host) => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/${host}.scss`;
        const css = `/tmp/astal-${host}/style.css`;

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

/** @param {string} host */
export const transpileTypeScript = async(host) => {
    const outPath = `/tmp/astal-${host}/index.js`;

    await execAsync([
        'bash', '-c',
        // Create the dir if it doesn't exist
        `mkdir -p /tmp/astal-${host}; ` +

        `bun build ${App.configDir}/${host}.ts ` +
        '--external resource:///* ' +
        '--external gi://* ' +
        '--external cairo ' +
        '--external */fzf.es.js ' +

        // Since bun wants to right in cwd, we just redirect stdin instead
        `> ${outPath}`,
    ]).catch(print);

    if (host !== 'greeter') {
        watchAndCompileSass(host);
    }

    return await import(`file://${outPath}`);
};
