import QtQuick 2.15
import QtMultimedia 5.9
import QtGraphicalEffects 1.12

Item {
    property string settingKey: '';
    property string validView: '';
    signal videoToggled(bool videoPlaying);

    function switchVideo() {
        videoPlayer.stop();
        videoPlayer.source = '';

        music.loud();

        videoPlayerTimer.restart();
        videoToggled(false);
    }

    function videoOff() {
        switchVideo();
        videoPlayerTimer.stop();
    }

    function quickVideoCallback(enabled) {
        if (enabled) videoPlayerTimer.interval = 500;
        else videoPlayerTimer.interval = 2000;
    }

    function quietVideoCallback(enabled) {
        if (enabled) videoPlayer.volume = 0;
        else videoPlayer.volume = .7;
    }

    Component.onCompleted: {
        addCurrentViewCallback(function (currentView) {
            if (currentView === validView) {
                switchVideo();
            } else {
                videoOff();
            }
        });

        quickVideoCallback(settings.get('quickVideo'));
        settings.addCallback('quickVideo', quickVideoCallback);

        quietVideoCallback(settings.get('quietVideo'));
        settings.addCallback('quietVideo', quietVideoCallback);
    }

    Connections {
        target: Qt.application;
        function onStateChanged() {
            if (videoPlayer.source === '') return;

            if (Qt.application.state === Qt.ApplicationActive) {
                switchVideo();
            } else {
                videoOff();
            }
        }
    }

    Timer {
        id: videoPlayerTimer;

        interval: 2000;
        repeat: false;
        onTriggered: {
            if (currentGame.assets.video === '') return;
            if (settings.get(settingKey) === false) return;
            if (currentView !== validView) return;

            videoToggled(true);

            if (videoPlayer.volume > 0) music.quiet();

            videoPlayer.source = currentGame.assets.video;
            videoPlayer.play();
        }
    }

    Video {
        id: videoPlayer;

        visible: false;
        volume: 0.7;
        source: currentGame.assets.video;
        autoPlay: false;
        loops: MediaPlayer.Infinite;
        width: parent.width * .75;
        height: parent.height * .75;
        anchors.centerIn: parent;
        fillMode: VideoOutput.PreserveAspectFit;
    }

    DropShadow {
        source: videoPlayer;
        verticalOffset: 10;
        color: '#60000000';
        radius: 30;
        samples: 61;
        cached: true;
        anchors.fill: videoPlayer;
    }
}