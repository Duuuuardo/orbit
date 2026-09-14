import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Orbit
import Orbit.Config
import Orbit.I18n
import qs.components
import qs.services
import qs.utils

Item {
    id: root

    readonly property bool hasWindow: !!Hypr.activeToplevel

    implicitWidth: layout.implicitWidth + Tokens.padding.extraLarge * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.extraLarge * 2

    ColumnLayout {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.extraLarge

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Tokens.spacing.medium

            IconImage {
                Layout.alignment: Qt.AlignVCenter

                asynchronous: true
                implicitWidth: 128
                implicitHeight: 128
                source: Icons.getAppIcon(Hypr.activeToplevel?.lastIpcObject.class ?? "", "image-missing")
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: Tokens.spacing.extraSmall

                StyledText {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 400

                    text: Hypr.activeToplevel?.title ?? Tr.trCtx("Desktop", "shown when no window is focused")
                    font: Tokens.font.headline.medium
                    elide: Text.ElideRight
                }

                StyledText {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 400

                    text: Hypr.activeToplevel?.lastIpcObject.class ?? ""
                    color: Colours.palette.m3onSurfaceVariant
                    elide: Text.ElideRight
                }
            }
        }

        StyledRect {
            Layout.alignment: Qt.AlignHCenter

            color: Colours.tPalette.m3surfaceContainer
            radius: Tokens.rounding.large
            clip: true
            implicitWidth: 420
            implicitHeight: 300

            Text {
                anchors.centerIn: parent
                visible: !root.hasWindow

                text: Tr.trCtx("No active window", "dashboard app tab")
                color: Colours.palette.m3onSurfaceVariant
            }

            ScreencopyView {
                anchors.fill: parent

                captureSource: Hypr.activeToplevel?.wayland ?? null 
                live: visible
                smooth: true
            }
        }
    }
}