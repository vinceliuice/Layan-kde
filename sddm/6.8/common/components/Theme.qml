import QtQuick

// Zentrale Konfiguration: liest theme.conf (config.*) und stellt Farben,
// Schriftgrößen und Texte bereit. Alle Komponenten bekommen dieses Objekt
// als `theme` übergeben.
QtObject {
    id: theme

    // Skalierungsfaktor (1.0 == 1080p). Wird von Main.qml gesetzt.
    property real unit: 1

    function opt(key, fallback) {
        const v = config[key]
        return (v === undefined || v === null || v === "") ? fallback : v
    }
    function flag(key, fallback) {
        const v = String(opt(key, fallback ? "true" : "false")).toLowerCase()
        return v === "true" || v === "1" || v === "yes" || v === "on"
    }
    function num(key, fallback) {
        const v = parseFloat(opt(key, fallback))
        return isNaN(v) ? fallback : v
    }
    function px(value) { return Math.round(value * unit) }

    // --- Farben ---------------------------------------------------------
    readonly property color accent: opt("accentColor", "#5657f5")
    readonly property color accentText: opt("accentTextColor", "#ffffff")
    readonly property color text: opt("textColor", "#ffffff")
    readonly property color errorColor: opt("errorColor", "#ff7b7b")
    readonly property color fallbackColor: opt("fallbackColor", "#25252d")
    readonly property color panel: opt("panelColor", "#2b2b36")
    readonly property color panelText: opt("panelTextColor", "#ffffff")
    readonly property color shadow: "#99000000"

    // --- Hintergrund ----------------------------------------------------
    readonly property string background: opt("background", "background.jpg")
    readonly property real blur: Math.max(0, Math.min(1, num("blur", 0)))
    readonly property real dim: Math.max(0, Math.min(1, num("dim", 0)))

    // --- Schrift --------------------------------------------------------
    readonly property string fontFamily: opt("fontFamily", Qt.application.font.family)
    readonly property int fontBase: px(num("fontSize", 10) * 1.7)
    readonly property int clockSize: px(num("clockSize", 132))
    readonly property int dateSize: Math.round(fontBase * 1.35)

    // --- Verhalten ------------------------------------------------------
    readonly property bool showClock: flag("showClock", true)
    readonly property bool showDate: flag("showDate", true)
    readonly property bool showHostname: flag("showHostname", false)
    readonly property bool loginOnAllScreens: flag("loginOnAllScreens", false)
    readonly property bool virtualKeyboard: flag("virtualKeyboard", true)
    readonly property string timeFormat: opt("timeFormat", "")
    readonly property string dateFormat: opt("dateFormat", "")
    readonly property string passwordCharacter: opt("passwordCharacter", "●")

    // --- Texte ----------------------------------------------------------
    readonly property Strings s: Strings {}
}
