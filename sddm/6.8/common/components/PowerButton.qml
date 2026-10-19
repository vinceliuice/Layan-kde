import QtQuick
import QtQuick.Controls.Basic

// Rundes Icon mit Beschriftung (Ruhezustand, Neustart, ...).
AbstractButton {
    id: control

    required property var theme
    property url iconSource
    property real iconSize: theme.px(60)

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    implicitWidth: Math.max(iconSize, label.implicitWidth) + theme.px(32)
    implicitHeight: iconSize + label.implicitHeight + theme.px(22)
    opacity: enabled ? 1 : 0.35

    Accessible.name: text
    Accessible.role: Accessible.Button

    background: Rectangle {
        radius: control.theme.px(14)
        color: control.theme.text
        opacity: control.visualFocus ? 0.12 : (control.hovered ? 0.07 : 0)
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    contentItem: Column {
        spacing: control.theme.px(10)

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: control.iconSize
            height: control.iconSize
            source: control.iconSource
            sourceSize: Qt.size(control.iconSize * 2, control.iconSize * 2)
            smooth: true
            scale: control.pressed ? 0.92 : (control.hovered ? 1.08 : 1)
            Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        }

        Text {
            id: label
            anchors.horizontalCenter: parent.horizontalCenter
            text: control.text
            color: control.theme.text
            font.family: control.theme.fontFamily
            font.pixelSize: control.theme.fontBase
            opacity: control.hovered || control.visualFocus ? 1 : 0.85
        }
    }
}
