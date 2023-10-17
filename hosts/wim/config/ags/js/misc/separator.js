import { Widget } from '../../imports.js';
const { Box } = Widget;


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
}
