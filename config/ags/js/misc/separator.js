import { Widget } from '../../imports.js';
const { Box } = Widget;


export const Separator = width => Box({
  style: `min-width: ${width}px;`,
});
