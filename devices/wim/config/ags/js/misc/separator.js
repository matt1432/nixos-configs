import { Box } from 'resource:///com/github/Aylur/ags/widget.js';


export default (size, { vertical = false, css = '', ...props } = {}) => {
    if (vertical) {
        return Box({
            css: `min-height: ${size}px; ${css}`,
            ...props,
        });
    }
    else {
        return Box({
            css: `min-width: ${size}px; ${css}`,
            ...props,
        });
    }
};
