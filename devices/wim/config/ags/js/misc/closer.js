import App from 'resource:///com/github/Aylur/ags/app.js';


export default () => {
    Array.from(App.windows)
        .filter(w => w[1].closeOnUnfocus && w[1].closeOnUnfocus !== 'stay')
        .forEach(w => {
            App.closeWindow(w[0]);
        });
};
