import { Widget, Box } from 'resource:///com/github/Aylur/ags/widget.js';
import WebKit2 from 'gi://WebKit2';
import PopupWindow from './misc/popup.js';

const WebView = Widget.subclass(WebKit2.WebView);


export default () => {
    const view = WebView({
        hexpand: true,
    });

    view.load_uri('https://search.nixos.org');

    return PopupWindow({
        name: 'browser',
        visible: true,
        focusable: true,
        layer: 'top',
        child: Box({
            css: 'min-height: 600px; min-width: 800px;',
            children: [view],
        }),
    });
};
