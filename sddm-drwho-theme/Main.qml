import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import QtMultimedia
import "Components"

Pane {
    id: root

    // screen settings — leave ScreenHeight/ScreenWidth at 0 to match the real display
    readonly property int configuredHeight: config.intValue("ScreenHeight")
    readonly property int configuredWidth: config.intValue("ScreenWidth")
    height: configuredHeight > 0 ? configuredHeight : Screen.height
    width: configuredWidth > 0 ? configuredWidth : Screen.width
    padding: config.intValue("ScreenPadding") || 0
    focus: true

    // palette
    palette.window: config.stringValue("BackgroundColor")
    palette.highlight: config.stringValue("HighlightBackgroundColor")
    palette.highlightedText: config.stringValue("HighlightTextColor")

    // fonts
    font.family: config.stringValue("FontFamily")
    font.pointSize: config.intValue("FontSize") || parseInt(height / 80) || 12

    // background config
    readonly property bool cropBG: config.boolValue("CropBackground")
    readonly property real dimBG: config.realValue("DimBackground")
    readonly property string dimBGColor: config.stringValue("DimBackgroundColor")
    readonly property bool haveFormBG: config.boolValue("HaveFormBackground")
    readonly property string formBGColor: config.stringValue("FormBackgroundColor")
    readonly property string backgroundPlaceholder: config.stringValue("BackgroundPlaceholder")
    readonly property real backgroundSpeed: config.realValue("BackgroundSpeed")
    readonly property string backgroundHAlignment: config.stringValue("BackgroundHorizontalAlignment")
    readonly property string backgroundVAlignment: config.stringValue("BackgroundVerticalAlignment")
    readonly property bool pauseBackground: config.boolValue("PauseBackground")
    readonly property string themeBg: config.stringValue("Background")

    // keyboard
    readonly property real keyboardSz: config.realValue("KeyboardSize")
    readonly property string virtualKeyboardPos: config.stringValue("VirtualKeyboardPosition")

    //blur
    readonly property bool fullBlur: config.boolValue("FullBlur")
    readonly property bool partialBlur: config.boolValue("PartialBlur")
    readonly property int blurMax: config.intValue("BlurMax")
    readonly property real blur: config.realValue("Blur")

    readonly property bool rightToLeftLayout: config.boolValue("RightToLeftLayout")
    readonly property string formPosition: config.stringValue("FormPosition")

    readonly property bool leftleft: haveFormBG && !partialBlur && formPosition === "left" && backgroundHAlignment === "left"

    readonly property bool leftcenter: haveFormBG && !partialBlur && formPosition === "left" && backgroundHAlignment === "center"

    readonly property bool rightright: haveFormBG && !partialBlur && formPosition === "right" && backgroundHAlignment === "right"

    readonly property bool rightcenter: haveFormBG && !partialBlur && formPosition === "right" && backgroundHAlignment === "center"

    LayoutMirroring.enabled: rightToLeftLayout || Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Item {
        id: sizeHelper
        height: parent.height
        width: parent.width
        anchors.fill: parent

        Rectangle {
            id: tintLayer
            height: parent.height
            width: parent.width
            anchors.fill: parent
            z: 1
            color: root.dimBGColor
            opacity: root.dimBG
        }

        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            z: 1
            color: root.formBGColor
            visible: root.haveFormBG
            opacity: root.partialBlur ? 0.3 : 1
        }

        LoginForm {
            id: form
            screenHeight: root.height
            fontPointSize: root.font.pointSize
            fontFamily: root.font.family
            screenPadding: root.padding
            formPosition: root.formPosition
            rightToLeft: root.rightToLeftLayout
            virtualKeyboardRef: virtualKeyboard
            height: parent.height
            width: parent.width / 2.5
            anchors.left: root.formPosition === "left" ? parent.left : undefined
            anchors.horizontalCenter: root.formPosition === "center" ? parent.horizontalCenter : undefined
            anchors.right: root.formPosition === "right" ? parent.right : undefined
            z: 1
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            width: root.keyboardSz < 0.1 || root.keyboardSz > 1.0 ? parent.width * 0.4 : parent.width * root.keyboardSz
            anchors.bottom: parent.bottom
            anchors.left: root.virtualKeyboardPos === "left" ? parent.left : undefined
            anchors.horizontalCenter: root.virtualKeyboardPos === "center" ? parent.horizontalCenter : undefined
            anchors.right: root.virtualKeyboardPos === "right" ? parent.right : undefined
            z: 1
            y: root.height - root.height / 4
            opacity: 0
            state: "hidden"
            property bool keyboardActive: item ? item.active : false
            function switchState() {
                state = state === "hidden" ? "visible" : "hidden";
            }
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - virtualKeyboard.height
                        opacity: 1
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        y: root.height - root.height / 4
                        opacity: 0
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "hidden"
                    to: "visible"
                    SequentialAnimation {
                        ScriptAction {
                            script: {
                                form.focusActiveInput();
                                if (virtualKeyboard.item)
                                    virtualKeyboard.item.activated = true;
                                Qt.callLater(function() {
                                    Qt.inputMethod.show();
                                });
                            }
                        }
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                },
                Transition {
                    from: "visible"
                    to: "hidden"
                    SequentialAnimation {
                        ParallelAnimation {
                            NumberAnimation {
                                target: virtualKeyboard
                                property: "y"
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                            OpacityAnimator {
                                target: virtualKeyboard
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }
                        ScriptAction {
                            script: {
                                if (virtualKeyboard.item)
                                    virtualKeyboard.item.activated = false;
                                Qt.inputMethod.hide();
                            }
                        }
                    }
                }
            ]
        }

        Image {
            id: backgroundPlaceholderImage
            z: 10
            source: root.backgroundPlaceholder
            visible: false
        }

        AnimatedImage {
            id: backgroundImage

            MediaPlayer {
                id: player
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: root.backgroundSpeed < 1.0 || root.backgroundSpeed > 10.0 ? 1.0 : root.backgroundSpeed
                loops: -1
                onPlayingChanged: {
                    backgroundPlaceholderImage.visible = false;
                }
            }
            VideoOutput {
                id: videoOutput
                fillMode: root.cropBG ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
                anchors.fill: parent
            }
            height: parent.height
            width: root.haveFormBG && root.formPosition != "center" && !root.partialBlur ? parent.width - formBackground.width : parent.width
            anchors.left: root.leftleft || root.leftcenter ? formBackground.right : undefined
            anchors.right: root.rightright || root.rightcenter ? formBackground.left : undefined
            horizontalAlignment: root.backgroundHAlignment === "left" ? Image.AlignLeft : root.backgroundHAlignment === "right" ? Image.AlignRight : Image.AlignHCenter
            verticalAlignment: root.backgroundVAlignment === "top" ? Image.AlignTop : root.backgroundVAlignment === "bottom" ? Image.AlignBottom : Image.AlignVCenter
            speed: root.backgroundSpeed < 1.0 || root.backgroundSpeed > 10.0 ? 1.0 : root.backgroundSpeed
            paused: root.pauseBackground ? 1 : 0
            fillMode: root.cropBG ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            asynchronous: true
            cache: true
            clip: true
            mipmap: true
            Component.onCompleted: {
                var fileType = root.themeBg.substring(root.themeBg.lastIndexOf(".") + 1);
                const videoFileTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"];
                if (videoFileTypes.includes(fileType)) {
                    backgroundPlaceholderImage.visible = true;
                    player.source = Qt.resolvedUrl(config.Background);
                    player.play();
                } else {
                    backgroundImage.source = root.themeBg;
                }
            }
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask
            height: parent.height
            width: form.width
            anchors.centerIn: form

            sourceItem: backgroundImage
            sourceRect: Qt.rect(x, y, width, height)
            visible: root.fullBlur || root.partialBlur
        }

        MultiEffect {
            id: blur
            height: parent.height
            width: (root.fullBlur && !root.partialBlur && root.formPosition !== "center") ? parent.width - formBackground.width : root.fullBlur ? parent.width : form.width
            anchors.centerIn: root.fullBlur ? backgroundImage : form
            source: root.fullBlur ? backgroundImage : blurMask
            blurEnabled: true
            autoPaddingEnabled: false
            blur: root.blur < 0.0 || root.blur > 3.0 ? 2.0 : root.blur
            blurMax: root.blurMax < 2 || root.blurMax > 48 ? 48 : root.blurMax
            visible: root.fullBlur || root.partialBlur
        }
    }
}
