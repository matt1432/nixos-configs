import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync, monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';


const watchAndCompileSass = () => {
    const reloadCss = () => {
        const scss = `${App.configDir}/scss/main.scss`;
        const css = '/tmp/ags/style.css';

        execAsync(`sassc ${scss} ${css}`).then(() => {
            App.resetCss();
            App.applyCss(css);
        });
    };

    monitorFile(
        `${App.configDir}/scss`,
        reloadCss,
        'directory',
    );
    reloadCss();
};

const transpileTypeScript = async() => {
    const dir = '/tmp/ags';
    const promises = [];
    const files = (await execAsync([
        'find', `${App.configDir}/`,
        '-wholename', '*services/*.ts',
        '-o',
        '-wholename', '*/ts/*.ts',
    ])).split('\n');

    /** @param {string} p */
    const getDirectoryPath = (p) => p.substring(0, p.lastIndexOf('/'));

    files.forEach((file) => {
        const outDir = getDirectoryPath(dir + file
            .replace(`${App.configDir}/ts`, '/js')
            .replace(`${App.configDir}/services`, '/services'));

        promises.push(
            execAsync([
                'bun', 'build', file,
                '--outdir', outDir,
                '--external', '*',
            ]).catch(print),
        );
    });

    await Promise.all(promises);

    return await import(`file://${dir}/js/main.js`);
};

watchAndCompileSass();
export default (await transpileTypeScript()).default;
