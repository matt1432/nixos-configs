const { Window, EventBox } = ags.Widget;
const { closeWindow } = ags.App;

const ALWAYS_OPEN = [
  'closer',
  'bar',
  'notifications',
];

// TODO: close on scroll event too?
export const closeAll = () => {
  ags.App.windows.forEach(w => {
    if (!ALWAYS_OPEN.some(window => window === w.name))
      ags.App.closeWindow(w.name)
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
    connections: [[ags.App, (_b, _w, _v) => {
      if (!Array.from(ags.App.windows).some(w => w[1].visible &&
        !ALWAYS_OPEN.some(window => window === w[0]))) {
        closeWindow('closer');
      }
    }]],
  }),
});
