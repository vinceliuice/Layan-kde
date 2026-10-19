import QtQuick
import QtQuick.Controls.Basic

// Flache Textschaltfläche für die Fußzeile (Sitzung, Tastaturlayout, ...).
Button {
    id: control

    required property var theme

    flat: true
    hoverEnabled: true
    focusPolicy: Qt.StrongFocus
    leftPadding: theme.px(14)
    rightPadding: theme.px(14)
    topPadding: theme.px(8)
    bottomPadding: theme.px(8)

    background: Rectangle {
        radius: height / 2
        color: control.theme.text
        opacity: control.down || control.checked ? 0.16 : (control.visualFocus ? 0.12 : (control.hovered ? 0.08 : 0))
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }

    contentItem: Text {
        text: control.text
        color: control.theme.text
        font.family: control.theme.fontFamily
        font.pixelSize: Math.round(control.theme.fontBase * 0.95)
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight
    }
}
