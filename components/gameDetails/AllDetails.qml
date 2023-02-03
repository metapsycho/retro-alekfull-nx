import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15

import '../media' as Media

Item {
    id: allDetails;

    property alias video: gameDetailsVideo;
    property double actionButtonHeight: allDetails.height * 0.09;

    // get rid of newlines for the short description
    // also some weird kerning on periods and commas for some reason
    property var introDescText: {
        if (currentGame === null) return '';

        return currentGame.description
            .replace(/\n/g, ' ')
            .replace(/ {2,}/g, ' ')
            .replace(/\. {1,}/g, '.  ')
            .replace(/, {1,}/g, ',  ');
    }

    property var hasMoreButton: {
        if (currentGame === null) return false;
        if (currentGame.description) return true;
        return false;
    }

    property string boxFrontSrc: {
        if (currentGame === null) return '';
        return currentGame.assets.boxFront;
    }

    property string screenshotSrc: {
        if (currentGame === null) return '';
        return currentGame.assets.screenshot;
    }

    property string logoSrc: {
        if (currentGame === null) return '';
        return currentGame.assets.logo;
    }

    property string favoriteGlyph: {
        if (currentGame === null) return '';
        if (currentGame.favorite) return glyphs.favorite;
        return glyphs.unfavorite;
    }

    property double textSize: root.height * 0.055 * theme.fontScale;

    Component.onCompleted: {
        gameDetailsVideo.switchVideo();
        settings.addCallback('gameDetailsVideo', function () {
            gameDetailsVideo.switchVideo();
        });
    }

    Row {
        anchors.fill: parent;

        Rectangle {
            id: sectionMedia;

            width: parent.width / 2.5;
            height: parent.height;
            anchors.verticalCenter: parent.verticalCenter;
            color: theme.current.bgColorSecondary;

            Rectangle {
                anchors {
                    leftMargin: 20;
                    rightMargin: 20;
                    topMargin: 40;
                    bottomMargin: 40;
                }
                anchors.fill: parent;
                color: 'transparent';

                Rectangle {
                    anchors.fill: parent;
                    color: 'transparent';

                    Rectangle {
                        id: sectionScreen;
                        width: Math.min(parent.width, parent.height - actionButtonHeight - 10);
                        height: width;
                        anchors {
                            left: parent.left;
                            right: parent.right;
                            top: parent.top;
                        }
                        color: 'transparent';

                        Media.GameImage {
                            id: gameDetailsScreenshot;

                            anchors.fill: parent;
                            imageSource: screenshotSrc;
                        }

                        Media.GameVideo {
                            id: gameDetailsVideo;

                            anchors.fill: parent;
                            settingKey: 'gameDetailsVideo';
                            validView: 'gameDetails';
                            quickPlay: true;

                            onVideoToggled: {
                                gameDetailsScreenshot.videoPlaying = videoPlaying;
                                gameDetailsLogo.visible = videoPlaying;
                            }
                        }

                        Image {
                            id: gameDetailsLogo;

                            visible: false;
                            width: parent.width * .5;
                            height: parent.height * .5;
                            anchors {
                                right: parent.right;
                                bottom: parent.bottom;
                            }
                            fillMode: Image.PreserveAspectFit;
                            source: logoSrc;
                        }
                    }

                    RowLayout {
                        id: sectionBottons;
                        width: parent.width;
                        height: actionButtonHeight;
                        anchors {
                            left: parent.left;
                            right: parent.right;
                            bottom: parent.bottom;
                        }
                        spacing: parent.width * 0.075;

                        ActionButton {
                            id: playButton;

                            Layout.alignment: Qt.AlignCenter;
                            Layout.preferredWidth: 180;
                            Layout.fillHeight: true;

                            glyph: glyphs.play;

                            MouseArea {
                                anchors.fill: parent;

                                onClicked: {
                                    detailsButtonClicked('play');
                                }
                            }
                        }

                        ActionButton {
                            id: favoriteButton;

                            Layout.alignment: Qt.AlignCenter;
                            Layout.preferredWidth: 180;
                            Layout.fillHeight: true;

                            glyph: favoriteGlyph;

                            MouseArea {
                                anchors.fill: parent;

                                onClicked: {
                                    detailsButtonClicked('favorite');
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            width: parent.width - sectionMedia.width;
            height: parent.height;
            anchors.verticalCenter: parent.verticalCenter;
            color: theme.current.bgColor;

            Rectangle {
                anchors.fill: parent;
                anchors.margins: 30;
                color: 'transparent';

                Rectangle {
                    anchors.fill: parent;
                    color: 'transparent';

                    GameMetadata {
                        id: gameMetaData;

                        width: parent.width;
                        height: parent.height * .5 - 0.5;
                        anchors {
                            top: parent.top;
                            left: parent.left;
                        }
                    }

                    // divider
                    Rectangle {
                        width: parent.width;
                        height: 1;
                        anchors.centerIn: parent;

                        color: theme.current.dividerColor;
                    }

                    Rectangle {
                        id: sectionIntro;
                        color: 'transparent';

                        width: parent.width;
                        height: parent.height * .5 - 0.5;
                        anchors {
                            bottom: parent.bottom;
                            left: parent.left;
                        }

                        Text {
                            id: introDesc;

                            anchors.fill: parent;

                            text: introDescText;
                            wrapMode: Text.WordWrap;
                            horizontalAlignment: Text.AlignJustify;
                            verticalAlignment: Text.AlignTop;
                            color: theme.current.detailsColor;
                            lineHeight: 1.1;
                            elide: Text.ElideRight;

                            font {
                                family: serifFont.name;
                                pixelSize: textSize * 0.5;
                                letterSpacing: -0.1;
                                bold: true;
                            }

                            MouseArea {
                                anchors.fill: parent;

                                onClicked: {
                                    detailsButtonClicked('more');
                                }
                            }
                        }

                        MoreButton {
                            pixelSize: textSize * 0.52;
                            visible: hasMoreButton;

                            anchors {
                                right: introDesc.right;
                                bottom: introDesc.bottom;
                            }
                        }
                    }
                }
            }
        }
    }
}
