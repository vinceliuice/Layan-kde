import QtQuick
import QtQuick.Controls.Basic

MenuItem {
    id: item

    required property var theme
    property bool current: false

    implicitHeight: theme.px(38)
    leftPadding: theme.px(16)
    rightPadding: theme.px(16)

    background: Rectangle {
        radius: item.theme.px(9)
        color: item.highlighted ? item.theme.accent : "transparent"
    }

    contentItem: Text {
        text: item.text
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        font.family: item.theme.fontFamily
        font.pixelSize: item.theme.fontBase
        font.bold: item.current
        color: item.highlighted ? item.theme.accentText : item.theme.panelText
    }
}
