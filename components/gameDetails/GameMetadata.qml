import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    property double pixelSize;

    property double actionButtonHeight: {
        return Math.min(
            actionButtons.height * 0.7,
            root.height * 0.1,
        );
    }

    property string genreText: {
        if (currentGame.genreList.length === 0) { return null; }

        const genre = currentGame.genreList[0] ?? '';
        const split = genre.split(',');

        if (split[0].length === 0) { return null; }

        return split[0];
    }

    property string releaseDateText: {
        if (!currentGame.releaseYear) { return ''; }

        return 'Released ' + currentGame.releaseYear;
    }

    property string developedByText: {
        if (currentGame.developer) {
            return 'Dev\'d By ' + currentGame.developer;
        }

        if (currentGame.publisher) {
            return 'Pub\'d By ' + currentGame.publisher;
        }

        return '';
    }

    property var metadataText: {
        return [genreText, releaseDateText, developedByText]
            .filter(v => { return v !== null })
            .filter(v => { return v !== '' });
    }

    property string favoriteGlyph: {
        if (currentGame.favorite) return glyphs.favorite;
        return glyphs.unfavorite;
    }

    Text {
        id: title;

        width: parent.width;
        wrapMode: Text.WordWrap;
        maximumLineCount: 2;
        text: currentGame.title;
        lineHeight: 1.1;
        color: theme.current.detailsColor;

        font {
            pixelSize: pixelSize;
            letterSpacing: -0.35;
            bold: true;
        }

        anchors {
            left: parent.left;
            top: parent.top;
        }
    }

    Column {
        id: metadata;

        spacing: 8;
        width: parent.width;

        anchors {
            top: title.bottom;
            topMargin: 8;
        }

        Repeater {
            model: metadataText;

            Text {
                text: modelData;
                color: theme.current.detailsColor;
                opacity: 0.5;
                width: parent.width;
                elide: Text.ElideRight
                maximumLineCount: 1;

                font {
                    pixelSize: pixelSize * .75;
                    letterSpacing: -0.35;
                    bold: true;
                }
            }
        }
    }

    Row {
        id: actionButtons;

        spacing: parent.width * .075;
        width: parent.width;

        anchors {
            top: metadata.bottom;
            topMargin: pixelSize;
            bottom: parent.bottom;
        }

        ActionButton {
            id: playButton;

            glyph: glyphs.play;
            width: parent.width / 2;
            height: actionButtonHeight;
            anchors.verticalCenter: parent.verticalCenter;

            MouseArea {
                anchors.fill: parent;

                onClicked: {
                    buttonClicked('play');
                }
            }
        }

        ActionButton {
            id: favoriteButton;

            glyph: favoriteGlyph;
            width: parent.width / 2;
            height: actionButtonHeight;
            anchors.verticalCenter: parent.verticalCenter;


            MouseArea {
                anchors.fill: parent;

                onClicked: {
                    buttonClicked('favorite');
                }
            }
        }
    }
}