import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    property double textSize: root.height * 0.055 * theme.fontScale;

    property var metadataText: {
        const texts = [
            gameData.releaseDateText,
            gameData.genreText,
            gameData.developedByText,
            gameData.playersText,
            gameData.lastPlayedText
        ];
        return texts.filter(v => { return v !== null })
            .filter(v => { return v !== '' });
    }

    property string titleText: {
        if (currentGame === null) return '';
        return currentGame.title;
    }

    Text {
        id: title;

        width: parent.width;
        wrapMode: Text.WordWrap;
        maximumLineCount: 2;
        text: titleText;
        color: theme.current.detailsColor;
        elide: Text.ElideRight;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignLeft;

        font {
            family: serifFont.name;
            pixelSize: textSize;
            letterSpacing: -0.35;
            bold: true;
        }

        anchors {
            left: parent.left;
            top: parent.top;
            bottomMargin: 10;
        }
    }

    Text {
        id: gameRating;

        height: root.height * 0.055 * theme.current.fontScale * .6;
        anchors {
            left: parent.left;
            right: parent.right;
            top: title.bottom;
        }

        text: gameData.ratingText;
        color: theme.current.detailsColor;
        opacity: 0.5;
        
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignLeft;

        font {
            family: glyphs.name;
            pixelSize: textSize * .4;
        }
    }

    Column {
        id: metadata;

        spacing: 3;
        width: parent.width;

        anchors {
            top: gameRating.bottom;
            topMargin: 3;
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
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignLeft;

                font {
                    family: sansFont.name;
                    pixelSize: textSize * .4;
                    letterSpacing: -0.35;
                    bold: true;
                }
            }
        }
    }
}
