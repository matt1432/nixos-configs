import { Box } from 'resource:///com/github/Aylur/ags/widget.js';


export default (size, { vertical = false } = {}) => {
    if (vertical) {
        return Box({
            css: `min-height: ${size}px;`,
        });
    }
    else {
        return Box({
            css: `min-width: ${size}px;`,
        });
    }
};
