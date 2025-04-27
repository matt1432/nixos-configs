import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../Components/RoundCorner"
import "../../Config/Theme"

PanelWindow {
    id: toplevel

    color: "transparent"
    exclusiveZone: bar.height

    Theme {
        id: theme

    }

    anchors {
        left: true
        right: true
        top: true
    }

    Rectangle {
        id: bar

        color: theme.windowBg
        height: 30

        anchors {
            left: parent.left
            right: parent.right
        }

        Text {
            anchors.centerIn: parent
            color: theme.windowFg
            text: "hello world"
        }
    }

    RowLayout {
        spacing: bar.width - leftCorner.width - rightCorner.width

        anchors {
            left: parent.left
            right: parent.right
            top: bar.bottom
        }

        RoundCorner {
            id: leftCorner

            color: theme.windowBg
            corner: RoundCorner.Corner.TopLeft
        }

        RoundCorner {
            id: rightCorner

            color: theme.windowBg
            corner: RoundCorner.Corner.TopRight
        }
    }
}
