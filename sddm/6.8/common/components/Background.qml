import QtQuick
import QtQuick.Effects

// Vollflächiger Hintergrund (Bild oder Farbe), optional weichgezeichnet/abgedunkelt.
Item {
    id: root

    required property var theme
    property bool effectsEnabled: true

    Rectangle {
        anchors.fill: parent
        color: root.theme.fallbackColor
    }

    Image {
        id: image
        anchors.fill: parent
        source: root.theme.background !== "" ? Qt.resolvedUrl("../" + root.theme.background) : ""
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
        opacity: status === Image.Ready ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 400 } }

        layer.enabled: root.effectsEnabled && root.theme.blur > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blurMax: 64
            blur: root.theme.blur
            autoPaddingEnabled: false
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: root.theme.dim
        visible: opacity > 0
    }
}
