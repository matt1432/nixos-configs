const { Window, EventBox } = ags.Widget;
const { closeWindow } = ags.App;

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
  }),
});
