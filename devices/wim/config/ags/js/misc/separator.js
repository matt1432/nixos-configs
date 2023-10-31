import { Box } from 'resource:///com/github/Aylur/ags/widget.js';


export default (size, { vertical = false } = {}) => {
    if (vertical)  {
        return Box({
            style: `min-height: ${size}px;`,
        });
    }
    else {
        return Box({
            style: `min-width: ${size}px;`,
        });
    }
};
