// Types
import { PopupWindow } from 'global-types';


export default () => {
    (App.windows as PopupWindow[])
        .filter((w) => w &&
          w.close_on_unfocus &&
          w.close_on_unfocus !== 'stay')
        .forEach((w) => {
            App.closeWindow(w.name);
        });
};
