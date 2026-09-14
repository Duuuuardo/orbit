pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell.Wayland
import Orbit.Config
import qs.components
import qs.components.images
import qs.services

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    readonly property alias unlocking: unlockAnim.running

    contentItem.Config.screen: screen.name
    contentItem.Tokens.screen: screen.name

    color: "transparent"

    Connections {
        function onUnlock(): void {
            unlockAnim.start();
        }

        target: root.lock
    }

    SequentialAnimation {
        id: unlockAnim

        ParallelAnimation {
            Anim {
                target: content
                property: "opacity"
                to: 0
                type: Anim.StandardSmall
            }
            Anim {
                target: content
                property: "scale"
                to: 0
            }
            Anim {
                type: Anim.StandardLarge
                target: background
                property: "opacity"
                to: 0
            }
        }
        PropertyAction {
            target: root.lock
            property: "locked"
            value: false
        }
    }

    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: background
            property: "opacity"
            to: 1
            type: Anim.StandardLarge
        }
        Anim {
            target: content
            property: "opacity"
            to: 1
            type: Anim.DefaultEffects
        }
        Anim {
            target: content
            property: "scale"
            to: 1
        }
    }

    
    
    
    Item {
        id: background

        anchors.fill: parent
        opacity: 0

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: 0.35
            blurMax: 64
            blurMultiplier: 1
        }

        Loader {
            anchors.fill: parent
            sourceComponent: Config.lock.useWallpaper ? wallpaperBackground : screencopyBackground
        }
    }

    Component {
        id: screencopyBackground

        ScreencopyView {
            captureSource: root.screen
        }
    }

    Component {
        id: wallpaperBackground

        Loader {
            anchors.fill: parent
            sourceComponent: Config.lock.wallpaperVideo.length > 0 ? videoBackground : imageBackground
        }
    }

    Component {
        id: imageBackground

        CachingImage {
            path: Wallpapers.current
        }
    }

    Component {
        id: videoBackground

        WallpaperVideo {}
    }

    
    
    Item {
        id: content

        anchors.fill: parent
        visible: Config.lock.enabled
        opacity: 0
        scale: 0.95

        Content {
            anchors.fill: parent
            lock: root
        }
    }
}