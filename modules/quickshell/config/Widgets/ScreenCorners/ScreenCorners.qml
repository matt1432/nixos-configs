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
            exclusionMode: ExclusionMode.Normal
            margins.bottom: -1
            screen: modelData

            mask: Region {
                item: null
            }

            anchors {
                bottom: true
                left: true
                right: true
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
