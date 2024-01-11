import App from 'resource:///com/github/Aylur/ags/app.js';
import { monitorFile, exec } from 'resource:///com/github/Aylur/ags/utils.js';


export const watchAndCompileSass = () => {
    const reloadCss = () => {
        // Main scss file
        const scss = `${App.configDir}/scss/main.scss`;

        // Target css file
        const css = `${App.configDir}/style.css`;

        // Compile, reset, apply
        exec(`sassc ${scss} ${css}`);
        App.resetCss();
        App.applyCss(css);
    };

    monitorFile(
        // Directory that contains the scss files
        `${App.configDir}/scss`,

        reloadCss,

        // Specify that its a directory
        'directory',
    );
    reloadCss();
};

export const compileTypescript = () => {
    const ts = `${App.configDir}/ts/main.ts`;
    const js = `${App.configDir}/compiled.js`;

    exec(`bash -c 'cd ${App.configDir} && nix develop && bun install && tsc ${ts} --outfile ${js}'`);
};
