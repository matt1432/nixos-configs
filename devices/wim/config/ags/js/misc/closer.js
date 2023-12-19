import App from 'resource:///com/github/Aylur/ags/app.js';


export default () => {
    Array.from(App.windows)
        // @ts-expect-error
        .filter((w) => w[1].attribute?.close_on_unfocus &&
            // @ts-expect-error
            w[1].attribute?.close_on_unfocus !== 'stay')
        .forEach((w) => {
            App.closeWindow(w[0]);
        });
};
