import Quickshell
import QtQuick

import "./Widgets/ScreenCorners"
import "./Config/Theme"

ShellRoot {
    Theme {
        id: theme

    }

    ScreenCorners {
    }

    PanelWindow {
        color: theme.windowBg
        height: 30

        anchors {
            bottom: true
            left: true
            right: true
        }

        Text {
            anchors.centerIn: parent
            color: theme.windowFg
            text: "hello world"
        }
    }
}
