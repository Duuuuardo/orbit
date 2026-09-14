pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Orbit.Config
import qs.components
import qs.services

Item {
    id: root

    required property Props props
    required property ScreenState screenState

    ListModel {
        id: items
    }

    onVisibleChanged: {
        if (visible)
            listProc.running = true;
    }

    function shorten(text: string): string {
        if (text.length > 60)
            return text.substring(0, 60) + "…";
        return text;
    }

    function mimeOf(value: string): string {
        if (value.startsWith("iVBOR"))
            return "image/png";
        if (value.startsWith("/9j"))
            return "image/jpeg";
        if (value.startsWith("R0lGOD"))
            return "image/gif";
        if (value.startsWith("UklGR"))
            return "image/webp";
        return "text/plain";
    }

    function copyAt(index: int): void {
        const item = index >= 0 && index < items.count ? items.get(index) : null;
        if (!item)
            return;
        const mime = mimeOf(item.value);
        Quickshell.execDetached(["sh", "-c", `cliphist decode "${item.id}" | wl-copy --type ${mime}`]);
        root.screenState.clipboard = false;
    }

    function deleteAt(index: int): void {
        const item = index >= 0 && index < items.count ? items.get(index) : null;
        if (!item)
            return;
        Quickshell.execDetached(["cliphist", "delete", item.id]);
        listProc.running = true;
    }

    implicitWidth: Tokens.sizes.sidebar.width

    StyledRect {
        anchors.fill: parent
        radius: Tokens.rounding.extraLarge
        color: Colours.tPalette.m3surfaceContainerLow

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.medium
            spacing: Tokens.spacing.medium

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                MaterialIcon {
                    text: "content_paste"
                    color: Colours.palette.m3primary
                    fontStyle: Tokens.font.icon.medium
                    fill: 1
                }

                StyledText {
                    text: "Clipboard"
                    color: Colours.palette.m3onSurface
                    font: Tokens.font.body.large
                }

                MaterialIcon {
                    text: "history"
                    color: Colours.palette.m3onSurfaceVariant
                    fontStyle: Tokens.font.icon.medium
                }

                Item {
                    Layout.fillWidth: true
                }

                StyledText {
                    id: countLabel

                    text: "0"
                    color: Colours.palette.m3onSurfaceVariant
                    font: Tokens.font.mono.small
                }

                StateLayer {
                    Layout.alignment: Qt.AlignVCenter

                    implicitWidth: refreshIcon.implicitWidth + Tokens.spacing.extraSmall
                    implicitHeight: refreshIcon.implicitHeight

                    radius: Tokens.rounding.full
                    color: Colours.palette.m3onSurface
                    onClicked: listProc.running = true

                    MaterialIcon {
                        id: refreshIcon

                        anchors.centerIn: parent

                        text: "refresh"
                        color: Colours.palette.m3onSurfaceVariant
                        fontStyle: Tokens.font.icon.medium
                    }
                }
            }

            StyledRect {
                Layout.fillWidth: true
                implicitHeight: 1

                color: Colours.tPalette.m3outlineVariant
            }

            ListView {
                id: list

                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                model: items
                focus: true
                activeFocusOnTab: true
                keyNavigationWraps: true
                highlightMoveDuration: 120
                currentIndex: items.count > 0 ? 0 : -1

                highlight: Item {
                    z: 0

                    StyledRect {
                        anchors.fill: parent
                        anchors.margins: 2
                        radius: Tokens.rounding.medium
                        color: Colours.palette.m3secondaryContainer
                    }
                }

                delegate: Item {
                    required property int index
                    required property string preview
                    required property string value

                    width: list.width
                    height: 44

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Tokens.padding.small
                        anchors.rightMargin: Tokens.padding.small
                        spacing: Tokens.spacing.small

                        MaterialIcon {
                            text: value.startsWith("iVBOR") || value.startsWith("/9j") || value.startsWith("UklGR") ? "image" : "short_text"
                            color: Colours.palette.m3onSurfaceVariant
                            fontStyle: Tokens.font.icon.medium
                        }

                        StyledText {
                            Layout.fillWidth: true

                            text: root.shorten(preview)
                            color: Colours.palette.m3onSurfaceVariant
                            font: Tokens.font.body.medium
                        }

                        StateLayer {
                            Layout.alignment: Qt.AlignVCenter

                            visible: list.currentIndex === index
                            implicitWidth: deleteIcon.implicitWidth + Tokens.spacing.extraSmall
                            implicitHeight: deleteIcon.implicitHeight

                            radius: Tokens.rounding.full
                            color: Colours.palette.m3error
                            onClicked: root.deleteAt(index)

                            MaterialIcon {
                                id: deleteIcon

                                anchors.centerIn: parent

                                text: "close"
                                color: Colours.palette.m3onError
                                fontStyle: Tokens.font.icon.medium
                            }
                        }
                    }

                    StateLayer {
                        anchors.fill: parent

                        radius: Tokens.rounding.medium
                        color: Colours.palette.m3primary
                        onClicked: root.copyAt(index)
                    }
                }

                Keys.onUpPressed: event => {
                    event.accepted = true;
                    list.decrementCurrentIndex();
                }
                Keys.onDownPressed: event => {
                    event.accepted = true;
                    list.incrementCurrentIndex();
                }
                Keys.onReturnPressed: event => {
                    event.accepted = true;
                    root.copyAt(list.currentIndex);
                }
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Backspace || event.key === Qt.Key_Delete) {
                        event.accepted = true;
                        root.deleteAt(list.currentIndex);
                    }
                }
            }
        }
    }

    Process {
        id: listProc

        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                items.clear();
                const lines = text.split("\n");
                for (const line of lines) {
                    const parts = line.split("\t");
                    if (parts.length >= 2)
                        items.append({ id: parts[0], preview: root.shorten(parts[1]), value: parts[2] ?? "" });
                }
                countLabel.text = String(items.count);
                if (items.count > 0)
                    list.currentIndex = 0;
            }
        }
    }
}