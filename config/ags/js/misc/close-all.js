export const closeAll = () => {
  ags.App.windows.forEach(w => {
    if (w.name != 'bar')
      ags.App.closeWindow(w.name)
  });
};
