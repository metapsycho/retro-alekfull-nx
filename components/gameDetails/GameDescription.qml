import QtQuick 2.15
import QtGraphicalEffects 1.12

Item {
    id: gameDescription;

    function resetFlickable() {
        flickable.contentY = -flickable.topMargin;
    }

    function scrollUp() {
        flickable.contentY = Math.max(
            -flickable.topMargin,
            flickable.contentY - fullDesc.font.pixelSize,
        );
    }

    function scrollDown() {
        flickable.contentY =
            flickable.contentHeight + flickable.topMargin + flickable.bottomMargin > parent.height ?
            Math.min(
                flickable.contentY + fullDesc.font.pixelSize,
                flickable.contentHeight - parent.height + flickable.bottomMargin
            ) : -flickable.topMargin;
    }

    // solves some kerning issues with period and commas
    property var descText: {
        if (currentGame === null) return '';

        // return currentGame.description
        //     .replace(/\. {1,}/g, '.  ')
        //     .replace(/, {1,}/g, ',  ');
        return currentGame.description;
    }

    property var fullDescText: {
        return [descText, filenames].join("\n\n");
    }

    property var filenames: {
        if (currentGame === null) return '';
        if (currentGame.files.count === 1) {
            return 'file: ' + currentGame.files.get(0).path;
        }

        const files = [];
        for (let i = 0; i < currentGame.files.count; i++) {
            files.push(currentGame.files.get(i).path);
        }


        return "files:\n  - " + files.join("\n  - ");
    }

    Flickable {
        id: flickable;

        contentWidth: fullDesc.width;
        contentHeight: fullDesc.height;
        flickableDirection: Flickable.VerticalFlick;
        anchors.fill: parent;
        clip: true;
        bottomMargin: 40;
        leftMargin: 40;
        rightMargin: 40;
        topMargin: 40;

        Behavior on contentY {
            PropertyAnimation { easing.type: Easing.Linear; duration: 150; }
        }

        Text {
            id: fullDesc;

            width: gameDescription.width - flickable.leftMargin - flickable.rightMargin;
            text: fullDescText;
            wrapMode: Text.WordWrap;
            lineHeight: 1.1;
            color: theme.current.detailsColor;
            horizontalAlignment: Text.AlignJustify;

            font {
                family: serifFont.name;
                pixelSize: root.height * .036 * theme.fontScale;
                letterSpacing: -0.1;
                bold: true;
            }
        }
    }

    MouseArea {
        anchors.fill: parent;

        onClicked: {
            detailsButtonClicked('less');
        }
    }
}
