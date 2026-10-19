import QtQuick
import QtQuick.VirtualKeyboard

// Wird nur über einen Loader geladen: fehlt QtQuick.VirtualKeyboard, schlägt das
// Laden still fehl und der Umschalter in der Fußzeile bleibt ausgeblendet.
InputPanel {
    id: panel
    visible: active
    width: parent ? parent.width : 800
}
