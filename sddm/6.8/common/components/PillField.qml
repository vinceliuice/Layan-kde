import QtQuick
import QtQuick.Controls.Basic

// Eingabefeld im Layan-Look: vollflächige Akzent-Pille.
TextField {
    id: control

    required property var theme

    implicitHeight: theme.px(46)
    leftPadding: theme.px(22)
    rightPadding: theme.px(22)
    verticalAlignment: TextInput.AlignVCenter

    color: theme.accentText
    selectionColor: Qt.rgba(1, 1, 1, 0.35)
    selectedTextColor: theme.accentText
    placeholderTextColor: Qt.rgba(theme.accentText.r, theme.accentText.g, theme.accentText.b, 0.6)
    font.family: theme.fontFamily
    font.pixelSize: Math.round(theme.fontBase * 1.15)
    cursorDelegate: Rectangle {
        width: Math.max(1, control.theme.px(2))
        color: control.theme.accentText
        visible: control.activeFocus && control.cursorVisible
    }

    background: Rectangle {
        radius: height / 2
        color: control.theme.accent
        border.width: control.activeFocus ? Math.max(2, control.theme.px(2)) : 0
        border.color: Qt.rgba(1, 1, 1, 0.55)
        Behavior on border.width { NumberAnimation { duration: 120 } }
    }
}
