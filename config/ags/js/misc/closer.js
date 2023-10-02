import { App, Widget } from '../../imports.js';
const { Window, EventBox } = Widget;
const { closeWindow } = App;

const ALWAYS_OPEN = [
  'closer',
  'bar',
  'notifications',
];


// TODO: close on scroll event too?
export const closeAll = () => {
  App.windows.forEach(w => {
    if (!ALWAYS_OPEN.some(window => window === w.name))
      closeWindow(w.name)
  });
  closeWindow('closer');
};

export const Closer = Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: EventBox({
    onPrimaryClickRelease: () => closeAll(),
    connections: [[App, (_b, _w, _v) => {
      if (!Array.from(App.windows).some(w => w[1].visible &&
        !ALWAYS_OPEN.some(window => window === w[0]))) {
        closeWindow('closer');
      }
    }]],
  }),
});
