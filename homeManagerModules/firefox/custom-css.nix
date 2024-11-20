rounding:
# css
''
  /* Hide unused menu rows */
  .browser-toolbar>* #alltabs-button,
  #appMenu-fxa-status2,
  #appMenu-fxa-separator {
      display: none !important;
  }

  :root * {
      --margin-left-icons-personal: 3px !important;
      --tab-height-personal: 40px !important;
      --uc-tab-corner-height: 41px !important;
      --uc-vertical-toolbar-width: 46px !important;
  }

  /* Fix url font-size */
  #urlbar-input {
      font-size: large !important;
  }

  /* Fix left side of tabs going past what it should */
  scrollbox {
      margin-left: 5px;
  }

  /* https://github.com/Godiesc/firefox-gx/blob/main/Tricks/README.md */
  /* Extensions button into the "left-sidebar" - Immovable */
  :root:not([chromehidden~="toolbar"],
  [sizemode="fullscreen"]) #PersonalToolbar {
      --padding-top-left-sidebar: 110px !important; /* 182px to one-line config */
  }
  :root:not([chromehidden~="toolbar"],
  [sizemode="fullscreen"]) #unified-extensions-button {
      --toolbarbutton-hover-background: transparent !important;
      --toolbarbutton-active-background: transparent !important;
      position: fixed;
      display: flex;
      top: 42px !important;
      left: 1px !important;
      z-index: 2 !important;
      fill: var(--general-color) !important;
      width: calc(var(--uc-vertical-toolbar-width) - 4px) !important;
  }
  :root:not([chromehidden~="toolbar"],
  :root:not([chromehidden~="toolbar"],
  [sizemode="fullscreen"]) #unified-extensions-button:hover,
  [sizemode="fullscreen"]) #unified-extensions-button[open] {
      transform: scale(1.24) !important;
      transition: ease-in-out !important;
  }
  :root:not([chromehidden~="toolbar"],
  [sizemode="fullscreen"]) #unified-extensions-button:active {
      transform: scale(1.12) !important;
      transition-duration: 0ms !important;
  }

  /* Fix extension dialog going off screen */
  #appMenu-addon-installed-notification,
  #notification-popup {
      margin-top: -1px !important;
      margin-inline: -505px !important;
  }

  #customizationui-widget-panel {
      margin-top: -1px !important;
  }

  #PersonalToolbar .toolbarbutton-1 {
      margin-block: 0px !important;
  }

  #PersonalToolbar #PlacesToolbarItems>.bookmark-item {
      margin-block: 6px !important;
  }

  /* -------------------------------------------------------------- */
  /* Fix menu */
  :root:not([chromehidden~="toolbar"],
  [sizemode="fullscreen"]) #PanelUI-menu-button,
  :root[sizemode="maximized"] #appMenu-popup,
  :root[sizemode="maximized"] #appMenu-popup {
      --tab-height-personal: unset !important;
  }

  :root:not([chromehidden~="toolbar"])[sizemode="maximized"] #appMenu-popup>panelmultiview>box>box>panelview {
      padding-top: unset !important;
  }

  /* Hamburger menu width */
  :root:not([chromehidden~="toolbar"],
  :root:not([chromehidden~="toolbar"]) #PanelUI-menu-button .toolbarbutton-badge-stack,
  [sizemode="fullscreen"]):is([sizemode="maximized"]) #PanelUI-menu-button[open]>stack {
      min-width: 46px !important;
  }

  toolbar .toolbarbutton-1>.toolbarbutton-badge-stack {
      padding: 10px !important;
  }

  :root:not([chromehidden~="toolbar"]) #PanelUI-menu-button[open]>.toolbarbutton-badge-stack {
      width: unset !important;
      border-top-left-radius: ${toString rounding}px !important;
  }

  :root:not([chromehidden~="toolbar"]) #PanelUI-menu-button>stack {
      display: unset;
      align-items: unset !important;
  }

  /* Remove text and places panel correctly */
  :root:not([chromehidden~="toolbar"]) #PanelUI-menu-button>stack::after {
      width: unset !important;
      content: unset;
      color: unset !important;
      text-shadow: unset !important;
  }

  :root:not([chromehidden~="toolbar"])[sizemode="maximized"] #appMenu-popup {
      appearance: unset !important;
      margin-top: -1px !important;
      clip-path: unset;
      --arrowpanel-menuitem-padding: unset !important;
  }

  :root:is([sizemode="maximized"]):not([tabsintitlebar],
  [chromehidden~="toolbar"]) #appMenu-popup {
      margin-top: unset !important;
  }

  .subviewbutton {
      min-height: 40px !important;
  }
''
