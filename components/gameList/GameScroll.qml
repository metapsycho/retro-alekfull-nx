import QtQuick 2.15

import '../media' as Media

Item {
    property alias video: gameListVideo;
    property alias gamesListView: gamesListView;
    property var sortingFont: sansFont.name;
    property alias letter: skipLetter.letter;

    property double itemHeight: {
        //return gamesListView.height * .12 * theme.fontScale;
        return gamesListView.height * .09 * theme.fontScale;
    }

    property string imgSrc: {
        if (currentGame === null) return '';
        return currentGame.assets.boxFront;
    }

    property var sortingText: {
        if (sortKey === 'release') {
            sortingFont = sansFont.name;
            return gameData.releaseDateText;
        }

        if (sortKey === 'rating') {
            sortingFont = glyphs.name;
            return gameData.ratingText;
        }

        sortingFont = sansFont.name;
        return gameData.lastPlayedText;
    }

    property string noGameText: {
        if (nameFilter != '') {
            return 'No Games With "' + nameFilter + '"';
        }

        return 'No Games';
    }

    Component.onCompleted: {
        gamesListView.currentIndex = currentGameIndex;
        gamesListView.positionViewAtIndex(currentGameIndex, ListView.Center);

        settings.addCallback('gameListVideo', function () {
            gameListVideo.switchVideo();
        });
    }

    Text {
        visible: currentGameList.count === 0;
        text: noGameText;
        anchors.centerIn: parent;
        color: theme.current.blurTextColor;
        opacity: 0.5;

        font {
            family: sansFont.name;
            pixelSize: parent.height * .065;
            letterSpacing: -0.3;
            bold: true;
        }
    }

    ListView {
        id: gamesListView;

        model: currentGameList;
        delegate: lvGameDelegate;
        width: (parent.width / 2) - 20 - 8 - 4; // 20 is left margin
        height: parent.height - 24;
        highlightMoveDuration: 0;
        preferredHighlightBegin: itemHeight - 12; // height of an item minus top margin
        preferredHighlightEnd: parent.height - (itemHeight + 12); // height of an item plus bottom margin
        highlightRangeMode: ListView.ApplyRange;

        anchors {
            left: parent.left;
            leftMargin: 20;
            top: parent.top;
            topMargin: 12;
            bottom: parent.bottom;
            bottomMargin: 12;
        }

        highlight: Rectangle {
            color: collectionData.getColor(currentShortName);
            opacity: theme.current.bgOpacity;
            radius: 8;
            width: gamesListView.width;
        }

        onCurrentIndexChanged: {
            gameListVideo.switchVideo();
        }
    }

    Rectangle {
        id: listProgressBar;
        width: 4;
        height: parent.height * 0.98;
        visible: (itemHeight * currentGameList.count) > height;
        anchors {
            left: gamesListView.right;
            leftMargin: 2 + 4;
            verticalCenter: parent.verticalCenter;
        }
        color: theme.current.dividerColor;

        Rectangle {
            height: ((parent.height / itemHeight) / currentGameList.count) * parent.height;
            width: 8;
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top;
                topMargin: (parent.height - height) * (gamesListView.currentIndex / (currentGameList.count - 1));
            }
            color: collectionData.getColor(currentShortName);
            opacity: theme.current.bgOpacity * 0.7;
        }
    }

    Component {
        id: lvGameDelegate;

        GameItem {
            width: gamesListView.width;
            height: itemHeight;
        }
    }

    SkipLetter {
        id: skipLetter;

        anchors {
            verticalCenter: gamesListView.verticalCenter;
            horizontalCenter: gamesListView.horizontalCenter;
        }
    }

    Media.GameImage {
        id: gameListBoxart;

        width: parent.width / 2;
        height: parent.height;
        x: parent.width / 2;
        imageSource: imgSrc;
    }

    Media.GameVideo {
        id: gameListVideo;

        width: parent.width / 2;
        height: parent.height;
        x: parent.width / 2;
        settingKey: 'gameListVideo';
        validView: 'gameList';

        onVideoToggled: {
            gameListBoxart.videoPlaying = videoPlaying;
        }
    }

    Text {
        text: sortingText;
        color: theme.current.detailsColor;
        opacity: 0.5;
        width: parent.width / 2;
        height: parent.height * .95;
        x: parent.width / 2;
        verticalAlignment: Text.AlignBottom;
        horizontalAlignment: Text.AlignHCenter;

        font {
            family: sortingFont;
            pixelSize: parent.height * .04;
            bold: true;
        }
    }
}
