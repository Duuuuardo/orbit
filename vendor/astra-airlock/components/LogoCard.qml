pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "../services"

Rectangle {
    id: root

    radius: 28
    clip: true
    color: Colours.tPalette.m3surfaceContainer

    AnimatedLogo {
        anchors.centerIn: parent
        width: Math.min(parent.width - 32, parent.height - 32)
        height: width
    }
}
