import QtQuick
import QtQuick.Effects

// Runder Benutzer-Avatar mit Schatten. Ohne (ladbares) Benutzerbild wird ein
// Platzhalter direkt in QML gezeichnet, es wird keine Zusatzdatei benötigt.
Item {
    id: root

    required property var theme
    property url source
    property real size: 200

    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    property bool imageFailed: false
    readonly property bool usePlaceholder: imageFailed || source.toString() === ""

    onSourceChanged: imageFailed = false

    implicitWidth: size
    implicitHeight: size
    width: size
    height: size

    // Schattenwurf
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.theme.panel
        layer.enabled: !root.softwareRendering
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.theme.shadow
            shadowBlur: 0.9
            shadowVerticalOffset: root.theme.px(6)
            shadowOpacity: 0.55
            autoPaddingEnabled: true
        }
    }

    // Bild bzw. Platzhalter, rund maskiert
    Item {
        id: art
        anchors.fill: parent

        layer.enabled: !root.softwareRendering
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: mask
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Image {
            anchors.fill: parent
            visible: !root.usePlaceholder
            source: root.usePlaceholder ? "" : root.source
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(root.width * 2, root.height * 2)
            smooth: true
            mipmap: true
            asynchronous: true
            onStatusChanged: if (status === Image.Error) root.imageFailed = true
        }

        Rectangle {
            anchors.fill: parent
            visible: root.usePlaceholder
            color: Qt.lighter(root.theme.accent, 1.15)

            Rectangle { // Kopf
                width: parent.width * 0.34
                height: width
                radius: width / 2
                x: (parent.width - width) / 2
                y: parent.height * 0.20
                color: "#f2f2fb"
            }
            Rectangle { // Schultern
                width: parent.width * 0.70
                height: parent.height * 0.70
                radius: width / 2
                x: (parent.width - width) / 2
                y: parent.height * 0.66
                color: "#f2f2fb"
            }
        }
    }

    Item {
        id: mask
        width: root.width
        height: root.height
        visible: false
        layer.enabled: true
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "black"
        }
    }
}
