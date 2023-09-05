export const Closer = ags.Widget.Window({
  name: 'closer',
  popup: true,
  layer: 'top',
  anchor: 'top bottom left right',

  child: ags.Widget.EventBox({
    onPrimaryClickRelease: () => {
      ags.App.closeWindow('powermenu');
      ags.App.closeWindow('closer');
    },
  }),
});
