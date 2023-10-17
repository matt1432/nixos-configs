import { App, Widget } from '../../imports.js';
const { Revealer, Box, Window } = Widget;


export default ({
  name,
  child,
  transition = 'slide_down',
  onOpen = rev => {},
  ...props
}) => {
  let window = Window({
    name,
    popup: true,
    visible: false,
    layer: 'overlay',
    ...props,

    child: Box({
      style: 'min-height:1px; min-width:1px',
      child: Revealer({
        transition,
        transitionDuration: 500,
        connections: [[App, (rev, currentName, visible) => {
          if (currentName === name) {
            rev.reveal_child = visible;
            onOpen(child);

            if (visible && name !== 'overview')
              App.openWindow('closer');
          }
        }]],
        child: child,
      }),
    }),
  });
  window.getChild = () => child;
  return window;
}
