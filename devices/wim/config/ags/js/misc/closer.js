import { App } from '../../imports.js';

// TODO: find a way to not need this?
import Pointers from '../../services/pointers.js';


export default () => {
    const closableWindows = Array.from(App.windows).filter(w => {
        return w[1].closeOnUnfocus &&
               w[1].closeOnUnfocus !== 'none';
    });
    closableWindows.forEach(w => {
        App.closeWindow(w[0]);
    });
};
