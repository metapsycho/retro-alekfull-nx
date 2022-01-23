import QtQuick 2.15

import '../footer' as Footer
import '../header' as Header

Item {
    anchors.fill: parent;

    Keys.onUpPressed: {
        event.accepted = true;
        gameScroll.gamesListView.decrementCurrentIndex();
    }

    Keys.onDownPressed: {
        event.accepted = true;
        gameScroll.gamesListView.incrementCurrentIndex();
    }

    function onAcceptPressed() {
        /* currentGame.launch(); */
        debug.text = currentGame.title;
    }

    function onCancelPressed() {
        gameScroll.gamesListView.currentIndex = 0;
        currentView = 'collectionList';
    }

    Keys.onPressed: {
        if (api.keys.isCancel(event)) {
            event.accepted = true;
            onCancelPressed();
        }

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            onAcceptPressed();
        }
    }

    Rectangle {
        color: '#f3f3f3';
        anchors.fill: parent;
    }

    GameScroll {
        id: gameScroll;

        anchors {
            top: gameListHeader.bottom;
            bottom: gameListFooter.top;
            left: parent.left;
            right: parent.right;
        }
    }

    Footer.Component {
        id: gameListFooter;
        index: currentGameIndex + 1;
        total: currentCollection.games.count;

        buttons: [
            { title: 'Play', key: 'A', square: false, sigValue: 'accept' },
            { title: 'Back', key: 'B', square: false, sigValue: 'cancel' },
        ];

        onButtonClicked: {
            if (sigValue === 'accept') onAcceptPressed();
            if (sigValue === 'cancel') onCancelPressed();
        }
    }

    Header.Component {
        id: gameListHeader;

        showDivider: true;
        lightText: false;
        color: '#f3f3f3';
        showCollection: true;
    }
}
