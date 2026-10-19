import QtQuick
import QtQml

// Tastaturlayout-Auswahl über das SDDM-`keyboard`-Objekt.
FooterButton {
    id: root

    signal layoutChanged()

    readonly property var layouts: keyboard.layouts
    readonly property string currentName: {
        const l = layouts[keyboard.currentLayout]
        return l ? l.longName : ""
    }

    visible: layouts.length > 1
    text: theme.s.keyboard + ": " + currentName
    checkable: true
    checked: menu.visible
    onClicked: menu.visible ? menu.close() : menu.open()

    StyledMenu {
        id: menu
        theme: root.theme

        Instantiator {
            id: instantiator
            model: root.layouts
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: StyledMenuItem {
                required property int index
                required property var modelData
                theme: root.theme
                text: modelData.longName
                current: index === keyboard.currentLayout
                onTriggered: {
                    keyboard.currentLayout = index
                    root.layoutChanged()
                }
            }
        }
    }
}
