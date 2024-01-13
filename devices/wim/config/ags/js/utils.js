import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync, monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';


export const watchAndCompileSass = () => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/main.scss`;
        const css = '/tmp/ags/style.css';

        execAsync(`sassc ${scss} ${css}`).then(() => {
            App.resetCss();
            App.applyCss(css);
        }).catch(reloadCss);
    };

    monitorFile(
        `${App.configDir}/scss`,
        reloadCss,
        'directory',
    );
    reloadCss();
};

export const transpileTypeScript = async(
    src = App.configDir,
    out = '/tmp/ags',
) => {
    const promises = [];
    const files = (await execAsync([
        'find', `${src}/`,
        '-wholename', `${src}/services/*.ts`,
        '-o',
        '-wholename', `${src}/ts/*.ts`,
    ])).split('\n');

    /** @param {string} p */
    const getDirectoryPath = (p) => p.substring(0, p.lastIndexOf('/'));

    files.forEach((file) => {
        const outDir = getDirectoryPath(out + file
            .replace(`${src}/ts`, '/ts')
            .replace(`${src}/services`, '/services'));

        promises.push(
            execAsync([
                'bun', 'build', file,
                '--outdir', outDir,
                '--external', '*',
            ]).catch(print),
        );
    });

    await Promise.all(promises);

    return `file://${out}/ts/main.js`;
};
