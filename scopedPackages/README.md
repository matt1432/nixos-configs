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
| `sponsorblock` | Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos. Other browsers: https://sponsor.ajay.app | https://sponsor.ajay.app |
| `stylus` | Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets. | https://add0n.com/stylus.html |
| `tampermonkey` | Tampermonkey is the world's most popular userscript manager. | https://tampermonkey.net |
| `ublock-origin` | Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory. | https://github.com/gorhill/uBlock#ublock-origin |
| `undoclosetabbutton` | Allows you to restore the tab you just closed with a single click---plus it can offer a list of recently closed tabs within a convenient context menu. | https://github.com/M-Reimer/undoclosetab |
| `youtube-no-translation` | Keeps YouTube content in its original language (Titles, Audio Tracks, Descriptions...) |  |
| `youtubelistview` | Brings back the list view for the subscriptions page and more. Click the extension icon for customization options. |  |

### mpvScripts

MPV scripts I use that aren't in nixpkgs.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `kdialog-open-files` | Use KDE KDialog to add files to playlist, subtitles to playing video or open URLs. Based on 'mpv-open-file-dialog' <https://github.com/rossy/mpv-open-file-dialog>. | https://gist.github.com/ntasos/d1d846abd7d25e4e83a78d22ee067a22 |
| `persist-properties` | Keeps selected property values (like volume) between player sessions. | https://github.com/d87/mpv-persist-properties |
| `pointer-event` | Mouse/Touch input event detection for mpv. | https://github.com/christoph-heinrich/mpv-pointer-event |
| `touch-gestures` | Touch gestures for mpv. | https://github.com/christoph-heinrich/mpv-touch-gestures |
| `undo-redo` | Accidentally seeked? No worries, simply undo.. Undo is not enough to fix your accidental seek? Well now you can redo as well.. | https://github.com/Eisa01/mpv-scripts?tab=readme-ov-file#undoredo |

### protonGE

My pinned versions of proton-ge-bin.

| Name | Description | Homepage |
| ---- | ----------- | -------- |
| `latest` | Compatibility tool for Steam Play based on Wine and additional components. (This is intended for use in the `programs.steam.extraCompatPackages` option only.) | https://github.com/GloriousEggroll/proton-ge-custom |
