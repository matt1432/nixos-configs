const { Window, EventBox } = ags.Widget;
const { windows, closeWindow } = ags.App;

export const Closer = Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: EventBox({
    onPrimaryClickRelease: () => {
      windows.forEach(w => {
        if (w.name != 'bar')
          closeWindow(w.name)
      });
    },
  }),
});
