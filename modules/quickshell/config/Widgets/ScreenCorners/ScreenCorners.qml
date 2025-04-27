import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import "../../Components/RoundCorner"

Scope {
    id: screenCorners

    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "quickshell:screenCorners"
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            screen: modelData

            mask: Region {
            }

            anchors {
                bottom: true
                left: true
                right: true
                top: true
            }

            RoundCorner {
                anchors.left: parent.left
                anchors.top: parent.top
                corner: RoundCorner.Corner.TopLeft
            }

            RoundCorner {
                anchors.right: parent.right
                anchors.top: parent.top
                corner: RoundCorner.Corner.TopRight
            }

            RoundCorner {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                corner: RoundCorner.Corner.BottomLeft
            }

            RoundCorner {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                corner: RoundCorner.Corner.BottomRight
            }
        }
    }
}
