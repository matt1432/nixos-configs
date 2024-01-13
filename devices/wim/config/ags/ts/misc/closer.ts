import App from 'resource:///com/github/Aylur/ags/app.js';

// Types
import AgsWindow from 'types/widgets/window';


export default () => {
    (Array.from(App.windows) as Array<[string, AgsWindow]>)
        .filter((w) => w[1].attribute?.close_on_unfocus &&
            w[1].attribute?.close_on_unfocus !== 'stay')
        .forEach((w) => {
            App.closeWindow(w[0]);
        });
};
