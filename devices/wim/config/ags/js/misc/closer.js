import App from 'resource:///com/github/Aylur/ags/app.js';


export default () => {
    Array.from(App.windows)
        .filter(w => w[1].closeOnUnfocus)
        .forEach(w => {
            App.closeWindow(w[0]);
        });
};
