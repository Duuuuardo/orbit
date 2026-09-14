pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Astra.Airlock
import "../services"
import "../components"

Item {
    id: root

    required property string username
    required property string avatarPath

    readonly property int size: 120

    implicitWidth: size
    implicitHeight: size

    
    Rectangle {
        id: avatarCircle

        anchors.centerIn: parent
        width: root.size
        height: root.size
        radius: root.size / 2
        color: Colours.palette.m3surfaceContainerHighest

        
        Image {
            id: avatarImage
            anchors.fill: parent
            source: root.avatarPath
            fillMode: Image.PreserveAspectCrop
            visible: status === Image.Ready
            smooth: true
            layer.enabled: true
            layer.smooth: true
        }

        
        MaterialIcon {
            anchors.centerIn: parent
            text: "person"
            color: Colours.palette.m3onSurfaceVariant
            font.pointSize: 42
            visible: avatarImage.status !== Image.Ready
        }
    }
}
