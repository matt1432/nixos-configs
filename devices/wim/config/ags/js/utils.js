import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync, monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';


const watchAndCompileSass = () => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/main.scss`;
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

export const transpileTypeScript = async() => {
    await execAsync([
        'bun', 'build', `${App.configDir}/ts/main.ts`,
        '--outdir', '/tmp/ags',
        '--external', 'resource:///*',
        '--external', 'gi://*',
        '--external', 'cairo',
        '--external', '*/fzf.es.js',
    ]).catch(print);

    watchAndCompileSass();

    // The file is going to be there after transpilation
    // @ts-ignore
    return await import('file:///tmp/ags/main.js');
};
