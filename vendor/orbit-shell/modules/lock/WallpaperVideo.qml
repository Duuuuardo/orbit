import QtQuick
import QtMultimedia
import Orbit.Config

Item {
    id: root

    property string source: Config.lock.wallpaperVideo

    MediaPlayer {
        id: player

        source: root.source
        audioOutput: audio
        videoOutput: video
        loops: MediaPlayer.Infinite
    }

    AudioOutput {
        id: audio

        muted: true
    }

    VideoOutput {
        id: video

        anchors.fill: parent
        visible: player.hasVideo
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Component.onCompleted: {
        if (root.source.length > 0)
            player.play();
    }
}