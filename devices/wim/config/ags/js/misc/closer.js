import { App } from '../../imports.js';

// TODO: find a way to not need this?
import Pointers from '../../services/pointers.js';


export default () => {
    Array.from(App.windows)
        .filter(w => w[1].closeOnUnfocus)
        .forEach(w => {
            App.closeWindow(w[0]);
        });
};
