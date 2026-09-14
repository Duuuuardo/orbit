pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import M3Shapes
import Orbit.Config
import qs.components
import qs.services
import qs.utils

RowLayout {
    id: root

    required property int index
    required property int activeWsId
    required property var occupied
    required property int groupOffset
    required property bool shouldShow

    required property Repeater workspaceRepeater
    required property real layoutSpacing

    readonly property bool isWorkspace: true 
    
    readonly property int size: implicitWidth + (hasWindows ? Tokens.padding.extraSmall : 0)

    readonly property int ws: groupOffset + index + 1
    readonly property bool isOccupied: occupied[ws] ?? false
    readonly property bool hasWindows: isOccupied && Config.bar.workspaces.showWindows && (Config.bar.workspaces.maxWindowIcons > 0)
    readonly property bool focused: activeWsId === ws
    readonly property list<int> focusedShapeList: [MaterialShape.Slanted, MaterialShape.Oval, MaterialShape.Pill, MaterialShape.Triangle, MaterialShape.Arrow, MaterialShape.Diamond, MaterialShape.Pentagon, MaterialShape.Gem, MaterialShape.VerySunny, MaterialShape.Sunny, MaterialShape.Cookie4Sided, MaterialShape.Cookie6Sided, MaterialShape.Cookie7Sided, MaterialShape.Cookie9Sided, MaterialShape.Cookie12Sided, MaterialShape.Clover4Leaf, MaterialShape.SoftBurst, MaterialShape.Ghostish]

    readonly property real revealProgress: Math.max(0, Math.min(1, reveal))
    readonly property bool revealTransitionRunning: revealAnimation.running
    readonly property real precedingRevealProgress: {
        let progress = 0;

        for (let i = 0; i < index; ++i) {
            const workspace = workspaceRepeater.itemAt(i) as Workspace;
            if (workspace)
                progress = Math.max(progress, workspace.revealProgress);
        }

        return progress;
    }
    readonly property real targetX: {
        let offset = 0;

        for (let i = 0; i < index; ++i) {
            const workspace = workspaceRepeater.itemAt(i) as Workspace;
            if (workspace?.shouldShow)
                offset += workspace.size + layoutSpacing;
        }

        return offset;
    }

    property real reveal: shouldShow ? 1 : 0
    property real animatedSize: size

    function updateShape(): void {
        const shape = indicator.item as MaterialShape;
        if (!shape)
            return;

        if (focused)
            shape.shape = focusedShapeList[Math.floor(Math.random() * focusedShapeList.length)];
        else
            shape.shape = Qt.binding(() => isOccupied ? MaterialShape.Square : MaterialShape.Circle);
    }

    Layout.alignment: Qt.AlignVCenter
    Layout.preferredWidth: animatedSize * revealProgress
    Layout.leftMargin: layoutSpacing * Math.min(revealProgress, precedingRevealProgress)

    visible: shouldShow || revealProgress > 0
    opacity: revealProgress
    clip: true

    spacing: 0

    onFocusedChanged: updateShape()
    Component.onCompleted: updateShape()

    Loader {
        id: indicator

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: Config.bar.workspaces.displayType === BarWorkspaceDisplay.Text ? Math.round(Tokens.sizes.bar.innerWidth * 0.55) : Tokens.sizes.bar.innerWidth - Tokens.padding.small
        sourceComponent: Config.bar.workspaces.displayType === BarWorkspaceDisplay.Text ? textComponent : shapeComponent

        onItemChanged: root.updateShape()
    }

    Component {
        id: shapeComponent

        MaterialShape {
            implicitSize: Tokens.sizes.bar.innerWidth - Tokens.padding.small

            color: Config.bar.workspaces.occupiedBg || root.isOccupied || root.focused ? Colours.palette.m3onSurface : Colours.layer(Colours.palette.m3outlineVariant, 2)
            scale: root.focused ? 2 / 3 : root.isOccupied ? 1 / 3 : 1 / 4

            animationEasing: Tokens.anim.expressiveDefaultSpatial
            animationDuration: Tokens.anim.durations.expressiveDefaultSpatial * Tokens.anim.durations.scale

            Behavior on color {
                CAnim {}
            }

            Behavior on scale {
                Anim {}
            }
        }
    }

    Component {
        id: textComponent

        StyledText {
            animate: true
            text: {
                if (root.focused) {
                    const label = Config.bar.workspaces.activeLabel;
                    if (label)
                        return label;
                }

                if (root.focused || root.isOccupied) {
                    const label = Config.bar.workspaces.occupiedLabel;
                    if (label)
                        return label;
                }

                const label = Config.bar.workspaces.label;
                if (label)
                    return label;

                const ws = Hypr.workspaces.values.find(w => w.id === root.ws);
                const wsName = !ws || ws.name == root.ws ? root.ws : ws.name[0];

                const capitalisation = Config.bar.workspaces.capitalisation;
                if (capitalisation === BarWorkspaceCapitalisation.Upper)
                    return wsName.toString().toUpperCase();
                else if (capitalisation === BarWorkspaceCapitalisation.Lower)
                    return wsName.toString().toLowerCase();
                return wsName;
            }
            color: root.focused ? Colours.palette.m3onPrimary : root.isOccupied ? Colours.palette.m3onSurface : Colours.layer(Colours.palette.m3outlineVariant, 2)
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            font.family: Tokens.font.workspaces
            font.pixelSize: Math.round(Tokens.sizes.bar.innerWidth * 0.55)
            font.weight: Font.DemiBold
        }
    }

    Loader {
        id: windows

        asynchronous: true

        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: Tokens.spacing.extraSmall
        Layout.rightMargin: Tokens.spacing.extraSmall

        visible: active
        active: root.hasWindows

        sourceComponent: Row {
            spacing: Tokens.spacing.extraSmall

            add: Transition {
                Anim {
                    properties: "scale"
                    from: 0
                    to: 1
                    easing: Tokens.anim.standardDecel
                }
            }

            move: Transition {
                Anim {
                    properties: "scale"
                    to: 1
                    easing: Tokens.anim.standardDecel
                }
                Anim {
                    properties: "x,y"
                }
            }

            Repeater {
                model: ScriptModel {
                    values: {
                        const windows = Hypr.toplevelsForWs(root.ws);
                        const maxIcons = root.Config.bar.workspaces.maxWindowIcons;
                        return maxIcons > 0 ? windows.slice(0, maxIcons) : windows;
                    }
                }

                Image {
                    required property var modelData

                    width: Math.round(Tokens.sizes.bar.innerWidth * 0.6)
                    height: Math.round(Tokens.sizes.bar.innerWidth * 0.6)
                    source: Icons.getAppIcon(modelData.lastIpcObject.class, "image-missing")
                    sourceSize.width: width * 2
                    sourceSize.height: height * 2
                    asynchronous: true
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    }

    Behavior on animatedSize {
        Anim {}
    }

    Behavior on reveal {
        Anim {
            id: revealAnimation

            type: Anim.DefaultEffects
        }
    }
}
