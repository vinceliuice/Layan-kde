import QtQuick
import QtQml

// Sitzungsauswahl (Plasma X11/Wayland, ...) über sessionModel.
FooterButton {
    id: root

    property int currentIndex: -1
    signal sessionChanged()

    readonly property string currentName: {
        // instantiator.count als Abhängigkeit: Neuauswertung, sobald Einträge existieren
        const o = instantiator.count > 0 ? instantiator.objectAt(currentIndex) : null
        return o ? o.text : ""
    }

    visible: sessionModel.count > 1
    text: theme.s.session + ": " + currentName
    checkable: true
    checked: menu.visible
    onClicked: menu.visible ? menu.close() : menu.open()

    StyledMenu {
        id: menu
        theme: root.theme

        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: StyledMenuItem {
                required property int index
                required property string name
                theme: root.theme
                text: name
                current: index === root.currentIndex
                onTriggered: {
                    root.currentIndex = index
                    root.sessionChanged()
                }
            }
        }
    }
}
