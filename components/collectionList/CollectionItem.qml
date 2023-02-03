import QtQuick 2.15
import QtGraphicalEffects 1.12
import SortFilterProxyModel 0.2

Item {
    MouseArea {
        anchors.fill: parent;
        onClicked: {
            collectionListView.currentIndex = index;
            onAcceptPressed();
        }
    }

    Image {
        id: bgImage;

        source: '../../assets/images/devices/' + collectionData.getImage(modelData.shortName) + '.jpg';
        fillMode: Image.PreserveAspectCrop;
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
        }
    }


    DropShadow {
        source: title;
        verticalOffset: 10;
        color: '#30000000';
        radius: 20;
        samples: 41;
        cached: true;
        anchors.fill: title;
    }

    Text {
        id: title;

        text: modelData.name;
        color: theme.current.titleColor;
        width: root.width * .46;
        wrapMode: Text.WordWrap;
        lineHeight: 0.8;

        font {
            family: serifFont.name;
            pixelSize: root.height * .075;
            bold: true;
        }

        anchors {
            left: parent.left;
            leftMargin: 30;
            bottom: gameCount.top;
            bottomMargin: root.height * .02;
        }
    }

    Text {
        id: gameCount;

        text: filteredGamesCollection.count + ' games';
        color: theme.current.titleColor;
        opacity: 0.7;

        anchors {
            left: parent.left;
            leftMargin: 30;
            bottom: parent.bottom;
            bottomMargin: root.height * .02;
        }

        font {
            family: sansFont.name;
            pixelSize: root.height * .03;
            letterSpacing: -0.3;
            bold: true;
        }
    }

    SortFilterProxyModel {
        id: filteredGamesCollection;

        sourceModel: allCollections[collectionListView.currentIndex].games;
        filters: [
            ValueFilter { roleName: 'favorite'; value: true; enabled: onlyFavorites; },
            ExpressionFilter { enabled: onlyMultiplayer; expression: { return players > 1; } },
            RegExpFilter { roleName: 'title'; pattern: nameFilter; caseSensitivity: Qt.CaseInsensitive; enabled: nameFilter !== ''; }
        ]
    }

    Text {
        text: collectionData.getVendorYear(modelData.shortName);
        color: theme.current.titleColor;
        opacity: 0.7;

        font {
            family: serifFont.name;
            capitalization: Font.AllUppercase;
            pixelSize: root.height * .025;
            letterSpacing: 1.3;
            bold: true;
        }

        anchors {
            left: parent.left;
            leftMargin: 30;
            bottom: title.top;
        }
    }
}
