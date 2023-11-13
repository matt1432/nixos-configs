import { Box } from 'resource:///com/github/Aylur/ags/widget.js';


export default (size, { vertical = false, ...props } = {}) => {
    if (vertical) {
        return Box({
            css: `min-height: ${size}px;`,
            ...props,
        });
    }
    else {
        return Box({
            css: `min-width: ${size}px;`,
            ...props,
        });
    }
};
