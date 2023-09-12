const { Window, EventBox } = ags.Widget;
const { closeWindow } = ags.App;

import { closeAll } from './close-all.js';

export const Closer = Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: EventBox({
    onPrimaryClickRelease: () => closeAll(),
  }),
});
