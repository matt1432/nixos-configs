{...}: {
  programs = {
    wezterm = {
      enable = true;

      extraConfig =
        # lua
        ''
          local config = wezterm.config_builder();

          -- default stuff
          config.disable_default_key_bindings = true;
          config.enable_wayland = false;

          -- theme & appearance
          config.color_scheme = 'Dracula';
          config.xcursor_theme = 'Dracula-cursors';

          config.audible_bell = 'Disabled';

          config.hide_tab_bar_if_only_one_tab = true;
          config.window_background_opacity = 0.8;
          config.window_padding = {
              top = 0,
              right = 0,
              bottom = 0,
              left = 0,
          };

          -- disable ligatures
          config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' };
          config.font = wezterm.font('JetBrains Mono');

          -- scrollback
          config.enable_scroll_bar = true;
          config.scrollback_lines = 3500;

          config.keys = {
            {
                -- Spawn a window with from the cwd
                key = 'Enter',
                mods = 'SHIFT|CTRL',
                action = wezterm.action.SpawnWindow,
            },
            {
                key='C',
                mods='CTRL|SHIFT',
                action=wezterm.action({ CopyTo='Clipboard' }),
            },
            {
                mods='CTRL|SHIFT',
                key='V',
                action=wezterm.action({ PasteFrom='Clipboard' }),
            },
          };

          return config;
        '';
    };
  };
}
