import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property var theme
    property date now: new Date()

    spacing: theme.px(4)

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: root.theme.timeFormat !== ""
              ? Qt.formatTime(root.now, root.theme.timeFormat)
              : root.now.toLocaleTimeString(Qt.locale(), Locale.ShortFormat)
        color: root.theme.text
        font.family: root.theme.fontFamily
        font.pixelSize: root.theme.clockSize
        font.weight: Font.Light
        renderType: Text.NativeRendering
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        visible: root.theme.showDate
        text: root.theme.dateFormat !== ""
              ? Qt.formatDate(root.now, root.theme.dateFormat)
              : root.now.toLocaleDateString(Qt.locale(), Locale.LongFormat)
        color: root.theme.text
        opacity: 0.8
        font.family: root.theme.fontFamily
        font.pixelSize: root.theme.dateSize
    }
}
