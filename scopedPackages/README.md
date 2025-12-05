# ScopedPackages

This directory contains every package scopes exposed by this flake.

## List of my package scopes found in `self.scopedPackages`

### dracula

Custom derivations that each represent an app's Dracula Theme.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `bat` | Dark theme for bat based on the Dracula Sublime theme. | https://github.com/matt1432/bat |
| `git` | Dark theme for Git. | https://github.com/dracula/git |
| `gtk` | Dracula variant of the Ant theme | https://github.com/dracula/gtk |
| `plymouth` | Dark theme for Plymouth. Forked by me to add a password prompt and black background for more seemless boot sequence. | https://github.com/matt1432/dracula-plymouth |
| `sioyek` | Dark theme for Sioyek. | https://github.com/dracula/sioyek |
| `wallpaper` | Wallpaper based on the Dracula Theme. | https://github.com/aynp/dracula-wallpapers |

### firefoxAddons

Every extensions I use in my firefox module.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `bitwarden` | At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information. | https://bitwarden.com |
| `darkreader` | Dark mode for every website. Take care of your eyes, use dark theme for night and daily browsing. | https://darkreader.org/ |
| `floccus` | Securely synchronize bookmarks across Chrome, Firefox, Edge, and more using your own cloud storage. | https://floccus.org |
| `google-container` | THIS IS NOT AN OFFICIAL ADDON FROM MOZILLA! It is a fork of the Facebook Container addon. Prevent Google from tracking you around the web. The Google Container extension helps you take control and isolate your web activity from Google. | https://github.com/containers-everywhere/contain-google |
| `image-search-options` | A customizable reverse image search tool that conveniently presents a variety of top image search engines. | http://saucenao.com/ |
| `istilldontcareaboutcookies` | Community version of the popular extension "I don't care about cookies" https://github.com/OhMyGuus/I-Dont-Care-About-Cookies | https://github.com/OhMyGuus/I-Dont-Care-About-Cookies |
| `return-youtube-dislikes` | Returns ability to see dislike statistics on youtube |  |
| `sound-volume` | Up to 600% volume boost |  |
| `sponsorblock` | Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos. Other browsers: https://sponsor.ajay.app | https://sponsor.ajay.app |
| `stylus` | Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets. | https://add0n.com/stylus.html |
| `tampermonkey` | Tampermonkey is the world's most popular userscript manager. | https://tampermonkey.net |
| `ublock-origin` | Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory. | https://github.com/gorhill/uBlock#ublock-origin |
| `undoclosetabbutton` | Allows you to restore the tab you just closed with a single click---plus it can offer a list of recently closed tabs within a convenient context menu. | https://github.com/M-Reimer/undoclosetab |

### hass-components

Components I use for Home-Assistant that aren't in nixpkgs.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `extended-ollama-conversation` | Home Assistant custom component of conversation agent. It uses Ollama to control your devices. | https://github.com/TheNimaj/extended_ollama_conversation |
| `material-symbols` | Material Symbols for Home Assistant is a collection of 13,803 Google Material Symbols for use within Home Assistant. It uses the icon-set produced and maintained by iconify. | https://github.com/beecho01/material-symbols |
| `netdaemon` | An application daemon for Home Assistant written in .NET. | https://github.com/net-daemon/netdaemon |
| `spotifyplus` | Home Assistant integration for Spotify Player control, services, and soundtouchplus integration support. | https://github.com/thlucas1/homeassistantcomponent_spotifyplus |
| `tuya-local` | Local support for Tuya devices in Home Assistant. | https://github.com/make-all/tuya-local |
| `yamaha-soundbar` | Yamaha soundbar integration for Home Assistant. | https://github.com/osk2/yamaha-soundbar |

### lovelace-components

Lovelace components I use for Home-Assistant that aren't in nixpkgs.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `big-slider-card` | A card with a big slider for light entities in Home Assistant. | https://github.com/nicufarmache/lovelace-big-slider-card |
| `custom-sidebar` | Custom HACS plugin that allows you to personalise the Home Assistant's sidebar per user or device basis. | https://github.com/elchininet/custom-sidebar |
| `material-rounded-theme` | Material Design 3 Colors and Components in Home Assistant. | https://github.com/Nerwyn/material-rounded-theme |
| `material-you-utilities` | Material You color theme generation and Home Assistant component modification. | https://github.com/Nerwyn/ha-material-you-utilities |

### mpvScripts

MPV scripts I use that aren't in nixpkgs.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `kdialog-open-files` | Use KDE KDialog to add files to playlist, subtitles to playing video or open URLs. Based on 'mpv-open-file-dialog' <https://github.com/rossy/mpv-open-file-dialog>. | https://gist.github.com/ntasos/d1d846abd7d25e4e83a78d22ee067a22 |
| `modernz` | A sleek and modern OSC for mpv designed to enhance functionality by adding more features, all while preserving the core standards of mpv's OSC. | https://github.com/Samillion/ModernZ |
| `persist-properties` | Keeps selected property values (like volume) between player sessions. | https://github.com/d87/mpv-persist-properties |
| `pointer-event` | Mouse/Touch input event detection for mpv. | https://github.com/christoph-heinrich/mpv-pointer-event |
| `touch-gestures` | Touch gestures for mpv. | https://github.com/christoph-heinrich/mpv-touch-gestures |
| `undo-redo` | Accidentally seeked? No worries, simply undo.. Undo is not enough to fix your accidental seek? Well now you can redo as well.. | https://github.com/Eisa01/mpv-scripts?tab=readme-ov-file#undoredo |

### protonGE

My pinned versions of proton-ge-bin.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `latest` | Compatibility tool for Steam Play based on Wine and additional components. (This is intended for use in the `programs.steam.extraCompatPackages` option only.) | https://github.com/GloriousEggroll/proton-ge-custom |
