import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../../Components/RoundCorner"
import "../../Config/Theme"
import "../../Services/DateTime"

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
        height: 50

        anchors {
            left: parent.left
            right: parent.right
        }

        RoundButton {
            id: button

            anchors.centerIn: parent
            radius: 5

            background: Rectangle {
                id: background

                anchors.centerIn: parent
                color: {
                    if (button.down) {
                        return theme.windowBg;
                    } else if (button.hovered) {
                        return theme.lightWindowBg;
                    } else {
                        return theme.darkWindowBg;
                    }
                }
                height: clockText.height + 0.4 * clockText.height
                opacity: enabled ? 1 : 0.3
                radius: 5
                width: clockText.width + 0.1 * clockText.width

                Behavior on color {
                    ColorAnimation {
                        duration: 200
                        target: background
                    }
                }
            }
            contentItem: Text {
                id: clockText

                anchors.centerIn: parent
                color: theme.windowFg
                renderType: Text.NativeRendering
                text: DateTime.time

                font {
                    pointSize: 16
                    weight: 500
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
            }
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
