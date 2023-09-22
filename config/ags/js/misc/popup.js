const { Revealer } = ags.Widget;
const { closeWindow, openWindow } = ags.App;

export const PopUp = ({name, child, transition = 'slide_down', ...params}) => Revealer({
  ...params,
  // FIXME: popups don't work with revealers
  setup: () => {
    setTimeout(() => {
      closeWindow(name);
    }, 100);

    // my eyes hurt
    if (name == 'overview') {
      setTimeout(() => {
        openWindow(name);
        closeWindow(name);
      }, 700);
    }
  },
  transition,
  transitionDuration: 500,
  connections: [[ags.App, (revealer, currentName, visible) => {
    if (currentName === name) {
      revealer.reveal_child = visible;

      if (visible && name !== 'overview')
        openWindow('closer');
    }
  }]],
  child: child,
});
