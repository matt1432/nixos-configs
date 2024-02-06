const { execAsync, monitorFile } = Utils;


/** @param {string} host */
const watchAndCompileSass = (host) => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/${host}.scss`;
        const css = '/tmp/ags/style.css';

        execAsync(`sassc ${scss} ${css}`).then(() => {
            App.resetCss();
            App.applyCss(css);
        }).catch(print);
    };

    monitorFile(
        `${App.configDir}/scss`,
        reloadCss,
        'directory',
    );
    reloadCss();
};

/** @param {string} host */
export const transpileTypeScript = async(host) => {
    await execAsync([
        'bun', 'build', `${App.configDir}/${host}.ts`,
        '--outdir', '/tmp/ags',
        '--external', 'resource:///*',
        '--external', 'gi://*',
        '--external', 'cairo',
        '--external', '*/fzf.es.js',
    ]).catch(print);

    if (host !== 'greeter') {
        watchAndCompileSass(host);
    }

    // The file is going to be there after transpilation
    // @ts-ignore
    return await import(`file:///tmp/ags/${host}.js`);
};
