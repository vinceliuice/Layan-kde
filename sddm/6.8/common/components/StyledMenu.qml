import QtQuick
import QtQuick.Controls.Basic

// Popup-Menü mit Theme-Farben. Öffnet sich oberhalb des Eltern-Buttons.
Menu {
    id: menu

    required property var theme

    y: -height - theme.px(6)
    padding: theme.px(6)
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 90 }
    }

    background: Rectangle {
        implicitWidth: menu.theme.px(240)
        radius: menu.theme.px(14)
        color: menu.theme.panel
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.08)
    }
}
