pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Greetd
import Astra.Airlock
import "../services"
import "../components"
import "../modules"

Rectangle {
    id: root

    signal exitRequested()

    color: Colours.palette.m3background

    property bool panelVisible: Colours.skipClockPage
    property bool wallpaperEnabled: Colours.wallpaperEnabled
    property bool entered: false

    Component.onCompleted: {
        Qt.callLater(() => { root.entered = true; });
    }

    Connections {
        target: Colours
        function onSkipClockPageChanged() {
            root.panelVisible = Colours.skipClockPage;
        }
    }

    function exitTestMode() {
        root.exitRequested();
    }

    property string imageSource: "/var/cache/astra-airlock/wallpapers/" + Colours.currentUser
    onImageSourceChanged: {
        if (wallpaper.active) {
            wallpaper.active = false;
            wallpaperTop.source = imageSource;
        } else {
            wallpaper.active = true;
            wallpaper.source = imageSource;
        }
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        source: "/var/cache/astra-airlock/wallpapers/" + Colours.currentUser
        fillMode: Image.PreserveAspectCrop
        visible: root.enabled
        opacity: root.wallpaperEnabled ? 1 : 0
        scale: root.panelVisible ? 1 : 1.02
        property bool active: true

        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: root.panelVisible ? 0.7 : 0
            blurMax: 54
            blurMultiplier: 1.0
            Behavior on blur { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        }
    }

    Image {
        id: wallpaperTop
        anchors.fill: parent
        source: "/var/cache/astra-airlock/wallpapers/" + Colours.currentUser
        fillMode: Image.PreserveAspectCrop
        visible: true
        opacity: root.wallpaperEnabled && !wallpaper.active ? 1 : 0
        scale: root.panelVisible ? 1 : 1.02

        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: root.panelVisible ? 0.7 : 0
            blurMax: 54
            blurMultiplier: 1.0
            Behavior on blur { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        }
    }

    
    Item {
        id: bgLayer
        anchors.fill: parent
        opacity: root.entered ? 1 : 0
        scale: root.entered ? 1 : 0.97
        Behavior on opacity { NumberAnimation { duration: 650; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 650; easing.type: Easing.OutCubic } }

        
        LavaLamp {
            anchors.fill: parent
            blurry: root.panelVisible
            opacity: root.panelVisible ? 0.62 : 0.75
            Behavior on opacity { NumberAnimation { duration: 400 } }
        }

        
        
        
        WallpaperVideo {
            anchors.fill: parent
        }

        
        Item {
            anchors.fill: parent
            opacity: root.entered ? (root.panelVisible ? 0 : 1) : 0
            scale: root.entered ? (root.panelVisible ? 0.90 : 1) : 0.92
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
            Behavior on scale   { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

            IdleClock {
                anchors.centerIn: parent
            }

            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 48
                text: "PRESS ENTER OR ANY KEY TO UNLOCK"
                font.family: "Google Sans Flex"
                font.pointSize: 11
                font.weight: Font.DemiBold
                font.variableAxes: { "wdth": 80 }
                color: Colours.palette.m3onSurface
                font.letterSpacing: 2.0
                opacity: 0.60

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.25; duration: 1500; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 0.85; duration: 1500; easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    
    MouseArea {
        anchors.fill: parent
        enabled: !root.panelVisible
        onClicked: {
            root.panelVisible = true;
            keyCapture.forceActiveFocus();
        }
    }

    
    Row {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 24
        anchors.topMargin: root.entered ? 24 : 8
        spacing: 10
        z: 2000
        opacity: root.entered ? 1 : 0
        Behavior on opacity          { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on anchors.topMargin { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

        PowerMenu {
            id: powerMenu
            anchors.verticalCenter: parent.verticalCenter
        }

        BatteryIcon {
            id: batteryIcon
            anchors.verticalCenter: parent.verticalCenter
            visible: BatteryState.available
            size: 50
            percentage: BatteryState.percentage / 100
            charging: BatteryState.charging
        }
    }

    
    ActiveClock {
        id: activeClock
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 28
        anchors.topMargin: root.entered ? 24 : 8
        z: 2000
        opacity: root.entered ? (root.panelVisible && !Colours.locklikeEnabled ? 1 : 0) : 0
        Behavior on opacity          { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
        Behavior on anchors.topMargin { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
    }

    
    Item {
        anchors.fill: parent
        opacity: root.entered ? (root.panelVisible ? 1 : 0) : 0
        scale: root.entered ? (root.panelVisible ? 1 : 1.05) : 0.94
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on scale   { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

        Loader {
            id: activePanelLoader
            anchors.centerIn: parent
            sourceComponent: Colours.locklikeEnabled ? locklikeComp : standardComp
        }

        Component {
            id: standardComp
            Center {
                onDismissed: {
                    root.panelVisible = false;
                    keyCapture.forceActiveFocus();
                }
            }
        }

        Component {
            id: locklikeComp
            LocklikePanel {
                onDismissed: {
                    root.panelVisible = false;
                    keyCapture.forceActiveFocus();
                }
            }
        }
    }

    

    
    OnScreenKeyboard {
        id: osk
        z: 3000
        visible: Colours.oskActive
        opacity: Colours.oskActive ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 180 } }

        onKeyClicked: key => {
            if (activePanelLoader.item) {
                root.panelVisible = true;
                activePanelLoader.item.passwordBuffer += key;
            }
        }
        onBackspaceClicked: {
            if (activePanelLoader.item) {
                activePanelLoader.item.passwordBuffer = activePanelLoader.item.passwordBuffer.slice(0, -1);
            }
        }
        onClearClicked: {
            if (activePanelLoader.item) {
                activePanelLoader.item.passwordBuffer = "";
            }
        }
        onEnterClicked: {
            if (activePanelLoader.item) {
                activePanelLoader.item._submit();
            }
        }
        onCloseClicked: Colours.oskActive = false
    }

    
    Item {
        id: keyCapture
        anchors.fill: parent
        focus: true

        Component.onCompleted: forceActiveFocus()

        onActiveFocusChanged: {
            if (!activeFocus) {
                keyCapture.forceActiveFocus();
            }
        }

        Keys.onPressed: event => {
            
            if (!Greetd.available) {
                if ((event.key === Qt.Key_Q && (event.modifiers & Qt.ControlModifier))
                    || (event.key === Qt.Key_C && (event.modifiers & Qt.ControlModifier))) {
                    root.exitTestMode();
                    event.accepted = true;
                    return;
                }
            }

            
            if (!root.panelVisible) {
                if (event.key === Qt.Key_Escape) {
                    if (!Greetd.available) {
                        root.exitTestMode();
                        event.accepted = true;
                        return;
                    }
                }
                root.panelVisible = true;
                event.accepted = true;
                return;
            }

            
            if (root.panelVisible && activePanelLoader.item) {
                activePanelLoader.item.handleKey(event);
                event.accepted = true;
            }
        }
    }
}
