const { Window, EventBox } = ags.Widget;
const { closeWindow } = ags.App;

// TODO: close on scroll event too?
export const closeAll = () => {
  ags.App.windows.forEach(w => {
    if (w.name != 'bar' &&
        w.name != 'notifications')
      ags.App.closeWindow(w.name)
  });
};

export const Closer = Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: EventBox({
    onPrimaryClickRelease: () => closeAll(),
    connections: [[ags.App, (box, windowName, visible) => {
      if (!Array.from(ags.App.windows).some(w => w[1].visible && w[0] != 'bar' && w[0] != 'notifications' && w[0] != 'closer')) {
        closeWindow('closer');
      }
    }]],
  }),
});
