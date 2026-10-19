import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "components"

// Layan SDDM-Theme (Qt 6, SDDM >= 0.21).
// Bewusst ohne KDE-Module (kein org.kde.*, kein Qt5Compat): nur QtQuick,
// QtQuick.Controls und QtQuick.Effects. Läuft damit unabhängig von der Plasma-Version.
Item {
    id: root

    width: 1920
    height: 1080

    // Skalierung relativ zu 1080p; bei Hochformat über die Breite begrenzt.
    readonly property real u: Math.max(0.4, Math.min(height / 1080, width / 1000))
    // SDDM startet pro Monitor eine eigene View, Tastaturfokus und Eingabemethode
    // gehören aber nur zur View des Primärmonitors (= erster Bildschirm in Qt).
    // Eingabe, Sitzungswahl und Bildschirmtastatur gibt es daher nur dort,
    // sofern `loginOnAllScreens` nicht gesetzt ist.
    readonly property bool isPrimaryScreen: {
        const screens = Qt.application.screens
        if (!screens || screens.length < 2 || Screen.name === "")
            return true
        return Screen.name === screens[0].name
    }
    readonly property bool showLogin: isPrimaryScreen || appTheme.loginOnAllScreens
    readonly property bool keyboardActive: vkLoader.item !== null && vkLoader.item.active
    property int sessionIndex: Math.max(0, sessionModel.lastIndex)

    Theme { id: appTheme; unit: root.u }

    // --- Hintergrund ----------------------------------------------------
    Background {
        anchors.fill: parent
        theme: appTheme
    }

    // --- Inhalt ---------------------------------------------------------
    Item {
        id: stage
        anchors.fill: parent
        opacity: 0

        NumberAnimation on opacity {
            id: fadeIn
            from: 0; to: 1; duration: 450
            easing.type: Easing.OutCubic
            running: true
        }
        NumberAnimation {
            id: fadeOut
            target: stage; property: "opacity"; to: 0; duration: 250
        }

        Item {
            id: content
            anchors.fill: parent

            // Bildschirmtastatur schiebt die Anmeldung nach oben.
            transform: Translate {
                y: {
                    if (!root.keyboardActive) return 0
                    const bottom = login.mapToItem(root, 0, login.height).y + appTheme.px(24)
                    return Math.min(0, root.height - vkLoader.item.height - bottom)
                }
                Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            }

            Clock {
                id: clock
                theme: appTheme
                visible: appTheme.showClock
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.height * 0.18 - height / 2
            }

            LoginPanel {
                id: login
                theme: appTheme
                visible: root.showLogin
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.height * 0.30
                onLoginRequested: (username, password) => sddm.login(username, password, root.sessionIndex)
            }

            // --- Ein-/Aus-Schalter ---------------------------------------
            RowLayout {
                id: powerRow
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.height * 0.79 - height / 2
                spacing: appTheme.px(18)
                visible: !root.keyboardActive

                PowerButton {
                    theme: appTheme
                    text: appTheme.s.sleep
                    iconSource: Qt.resolvedUrl("assets/suspend_primary.svgz")
                    enabled: sddm.canSuspend
                    onClicked: sddm.suspend()
                }
                PowerButton {
                    theme: appTheme
                    text: appTheme.s.restart
                    iconSource: Qt.resolvedUrl("assets/restart_primary.svgz")
                    enabled: sddm.canReboot
                    onClicked: sddm.reboot()
                }
                PowerButton {
                    theme: appTheme
                    text: appTheme.s.shutdown
                    iconSource: Qt.resolvedUrl("assets/shutdown_primary.svgz")
                    enabled: sddm.canPowerOff
                    onClicked: sddm.powerOff()
                }
                PowerButton {
                    theme: appTheme
                    text: login.manualUser ? appTheme.s.listUsers : appTheme.s.other
                    iconSource: Qt.resolvedUrl("assets/switch_primary.svgz")
                    visible: userModel.count > 0 && root.showLogin
                    onClicked: login.manualUser = !login.manualUser
                }
            }
        }

        // --- Fußzeile ------------------------------------------------------
        RowLayout {
            id: footer
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: appTheme.px(14)
            }
            spacing: appTheme.px(6)
            visible: root.showLogin && !root.keyboardActive

            FooterButton {
                id: vkButton
                theme: appTheme
                visible: vkLoader.status === Loader.Ready && vkLoader.item !== null
                text: appTheme.s.virtualKeyboard
                onClicked: {
                    login.passwordField.forceActiveFocus()
                    if (vkLoader.item) vkLoader.item.active = !vkLoader.item.active
                }
            }
            LayoutButton {
                theme: appTheme
                onLayoutChanged: login.passwordField.forceActiveFocus()
            }
            SessionButton {
                theme: appTheme
                currentIndex: root.sessionIndex
                onCurrentIndexChanged: root.sessionIndex = currentIndex
                onSessionChanged: login.passwordField.forceActiveFocus()
            }

            Item { Layout.fillWidth: true }

            Text {
                visible: appTheme.showHostname
                text: sddm.hostName
                color: appTheme.text
                opacity: 0.7
                font.family: appTheme.fontFamily
                font.pixelSize: appTheme.fontBase
                rightPadding: appTheme.px(10)
            }
        }

        // --- Bildschirmtastatur (optional) --------------------------------
        Loader {
            id: vkLoader
            z: 10
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            active: appTheme.virtualKeyboard && root.showLogin
            source: "components/VirtualKeyboard.qml"
        }
    }

    // --- SDDM-Signale --------------------------------------------------
    Connections {
        target: sddm

        function onLoginFailed() {
            fadeOut.stop()
            stage.opacity = 1
            login.loginFailed(appTheme.s.loginFailed)
        }
        function onLoginSucceeded() {
            // SDDM beendet den Greeter kurz danach; die Animation ist nur kosmetisch.
            fadeOut.start()
        }
        function onInformationMessage(message) {
            login.message = message
        }
    }

    // Beim Start Fokus erzwingen: SDDM aktiviert das Fenster teils erst verzögert.
    Timer {
        interval: 200
        running: true
        onTriggered: login.focusInput()
    }
}
