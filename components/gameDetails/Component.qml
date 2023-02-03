import QtQuick 2.15
import QtGraphicalEffects 1.12

import '../footer' as Footer

Item {
    id: gameDetails;
    anchors.fill: parent;

    property bool fullDescriptionShowing: false;
    property bool favoritesChanged: false;
    property var blurBg;
    property bool show: false;

    function onCancelPressed() {
        if (favoritesChanged === true) {
            updateGameIndex(currentGameIndex, true);
            favoritesChanged = false;
        }

        currentView = 'gameList';
        sounds.back();
    }

    function showPannel() {
        show = true;
    }

    function onAcceptPressed() {
        sounds.launch();
        currentGame.launch();
    }

    function onFiltersPressed() {
        currentGame.favorite = !currentGame.favorite;
        favoritesChanged = true;
        sounds.nav();
    }

    function onDetailsPressed() {
        if (!currentGame.description) return;

        fullDescriptionShowing = true;
        sounds.forward();
    }

    function hideFullDescription() {
        fullDescriptionShowing = false;
        fullDescription.resetFlickable();
        sounds.back();
    }

    function detailsButtonClicked(button) {
        switch (button) {
            case 'play':
                onAcceptPressed();
                break;

            case 'favorite':
                onFiltersPressed();
                break;

            case 'more':
                onDetailsPressed();
                break;

            case 'less':
                hideFullDescription();
                break;
        }
    }

    Keys.onUpPressed: {
        if (fullDescriptionShowing) {
            fullDescription.scrollUp();
            return;
        }

        event.accepted = true;
        const updated = updateGameIndex(currentGameIndex - 1);
        if (updated) {
            sounds.nav();
            allDetails.video.switchVideo();
        }
    }

    Keys.onDownPressed: {
        if (fullDescriptionShowing) {
            fullDescription.scrollDown();
            return;
        }

        event.accepted = true;
        const updated = updateGameIndex(currentGameIndex + 1);
        if (updated) {
            sounds.nav();
            allDetails.video.switchVideo();
        }
    }

    Keys.onPressed: {
        if (fullDescriptionShowing) {
            event.accepted = true;
            hideFullDescription();
            return;
        }

        if (api.keys.isCancel(event)) {
            event.accepted = true;
            onCancelPressed();
        }

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            onAcceptPressed();
        }

        if (api.keys.isDetails(event)) {
            event.accepted = true;
            onDetailsPressed();
        }

        if (api.keys.isFilters(event)) {
            event.accepted = true;
            onFiltersPressed();
        }
    }

    Rectangle {
        color: theme.current.detailsBlurColor;
        anchors.fill: parent

        FastBlur {
            width: blurBg.width;
            height: blurBg.height;
            anchors.centerIn: blurBg;
            radius: 40;
            opacity: .6;
            source: blurBg;
            cached: false;
        }
    }

    Item {
        anchors.fill: parent;

        Rectangle {

            anchors {
                top: parent.top;
                bottom: detailsFooter.top;
                left: parent.left;
                right: parent.right;
            }
            color: 'transparent';

            Rectangle {
                id: allDetailsPannel;

                width: parent.width * 0.8;
                height: parent.height * 0.85;
                color: theme.current.bgColor;

                anchors {
                    centerIn: parent;
                    verticalCenterOffset: root.height + height * .5;
                }

                AllDetails {
                    id: allDetails;
                    anchors.fill: parent;
                }
            }

            Rectangle {
                id: fullDescriptionPannel;
                width: allDetailsPannel.width;
                height: allDetailsPannel.height;
                anchors.centerIn: parent;
                color: theme.current.bgColor;
                visible: false;
                opacity: 0;

                FastBlur {
                    anchors.fill: parent;
                    radius: 80;
                    opacity: .4;
                    source: allDetailsPannel;
                    cached: false;
                }

                GameDescription {
                    id: fullDescription;
                    anchors.fill: parent;
                }

                state: fullDescriptionShowing ? 'ShowDesc' : 'HideDesc';
                states: [
                    State {
                        name: 'ShowDesc';
                        PropertyChanges { target: fullDescriptionPannel; visible: true }
                        PropertyChanges { target: fullDescriptionPannel; opacity: 1 }
                    },
                    State {
                        name: 'HideDesc';
                        PropertyChanges { target: fullDescriptionPannel; visible: false }
                        PropertyChanges { target: fullDescriptionPannel; opacity: 0 }
                    }
                ]

                transitions: [
                    Transition {
                        from: 'ShowDesc';
                        to: 'HideDesc';
                        SequentialAnimation {
                            NumberAnimation {
                                target: fullDescriptionPannel;
                                property: 'opacity';
                                duration: 500;
                                easing.type: Easing.OutCubic;
                            }
                            NumberAnimation {
                                target: fullDescriptionPannel;
                                property: 'visible'
                                duration: 0
                            }
                        }
                    },
                    Transition {
                        from: 'HideDesc';
                        to: 'ShowDesc';
                        SequentialAnimation {
                            NumberAnimation {
                                target: fullDescriptionPannel;
                                property: 'visible'
                                duration: 0
                            }
                            NumberAnimation {
                                target: fullDescriptionPannel;
                                property: 'opacity';
                                duration: 500;
                                easing.type: Easing.OutCubic;
                            }
                        }
                    }
                ]
            }
        }

        Footer.Component {
            id: detailsFooter;

            total: 0;

            buttons: [
                { title: 'Play', visible: !fullDescriptionShowing, key: theme.buttonGuide.accept, square: false, sigValue: 'accept' },
                { title: 'Back', key: theme.buttonGuide.cancel, square: false, sigValue: 'cancel' },
                { title: !fullDescriptionShowing ? 'More' : 'Less', key: theme.buttonGuide.details, square: false, sigValue: 'details' },
                { title: 'Favorite', visible: !fullDescriptionShowing, key: theme.buttonGuide.filters, square: false, sigValue: 'filters' },
            ];

            onFooterButtonClicked: {
                if (sigValue === 'accept') onAcceptPressed();
                if (sigValue === 'cancel') onCancelPressed();
                if (sigValue === 'filters') onFiltersPressed();
                if (sigValue === 'details') onDetailsPressed();
            }
        }
    }

    state: show ? 'Visible' : 'Invisible';
    states: [
        State {
            name: 'Visible';
            PropertyChanges { target: gameDetails; visible: true }
            PropertyChanges { target: allDetailsPannel.anchors; verticalCenterOffset: 0 }
        },
        State {
            name: 'Invisible';
            PropertyChanges { target: gameDetails; visible: false }
            PropertyChanges { target: allDetailsPannel.anchors; verticalCenterOffset: root.height + allDetailsPannel.height * .5; }
        }
    ]

    transitions: [
        Transition {
            from: 'Visible';
            to: 'Invisible';
            SequentialAnimation {
                NumberAnimation {
                    target: allDetailsPannel.anchors;
                    property: 'verticalCenterOffset';
                    duration: 200;
                    easing.type: Easing.OutCubic;
                }
                NumberAnimation {
                    target: gameDetails;
                    property: 'visible'
                    duration: 0
                }
            }
        },
        Transition {
            from: 'Invisible';
            to: 'Visible';
            SequentialAnimation {
                NumberAnimation {
                    target: gameDetails;
                    property: 'visible'
                    duration: 0
                }
                NumberAnimation {
                    target: allDetailsPannel.anchors;
                    property: 'verticalCenterOffset';
                    duration: 200;
                    easing.type: Easing.OutCubic;
                }
            }
        }
    ]
}
