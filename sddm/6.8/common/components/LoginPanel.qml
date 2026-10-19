import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

// Benutzerauswahl, Namensanzeige, Eingabefelder und Statusmeldung.
FocusScope {
    id: panel

    required property var theme

    // "Anderer…": Benutzername wird von Hand eingegeben.
    property bool manualUser: userModel.count === 0
    property string message: ""
    property bool busy: false

    readonly property bool listVisible: !manualUser && userModel.count > 0
    readonly property alias passwordField: passwordBox
    readonly property string selectedUser: userList.currentItem ? userList.currentItem.userName : ""
    readonly property string selectedDisplayName: userList.currentItem ? userList.currentItem.displayName : ""

    readonly property int avatarSize: theme.px(200)
    readonly property int cellWidth: theme.px(220)

    signal loginRequested(string username, string password)

    implicitWidth: Math.max(theme.px(520), column.implicitWidth)
    implicitHeight: column.implicitHeight
    width: implicitWidth
    height: implicitHeight

    function startLogin() {
        const user = manualUser ? userBox.text : selectedUser
        if (user === "")
            return
        message = ""
        busy = true
        passwordBox.forceActiveFocus()
        loginRequested(user, passwordBox.text)
    }

    function loginFailed(text) {
        busy = false
        message = text
        passwordBox.selectAll()
        passwordBox.forceActiveFocus()
        shake.restart()
    }

    function focusInput() {
        (manualUser && userBox.text === "" ? userBox : passwordBox).forceActiveFocus()
    }

    onManualUserChanged: Qt.callLater(focusInput)
    Component.onCompleted: {
        if (userModel.lastIndex >= 0)
            userList.currentIndex = userModel.lastIndex
    }

    ColumnLayout {
        id: column
        width: parent.width
        spacing: theme.px(14)
        enabled: !panel.busy

        transform: Translate { id: shakeOffset }

        // --- Avatar / Benutzerliste -------------------------------------
        Item {
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: panel.listVisible
                           ? Math.min(Math.max(userModel.count, 1), 3) * panel.cellWidth
                           : panel.avatarSize
            implicitHeight: panel.avatarSize + theme.px(24)

            ListView {
                id: userList
                anchors.fill: parent
                visible: panel.listVisible
                orientation: ListView.Horizontal
                model: userModel
                clip: userModel.count > 1
                interactive: userModel.count > 1
                boundsBehavior: Flickable.StopAtBounds
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: width / 2 - panel.cellWidth / 2
                preferredHighlightEnd: width / 2 + panel.cellWidth / 2
                highlightMoveDuration: 260
                onCurrentIndexChanged: panel.message = ""

                delegate: Item {
                    id: cell
                    required property int index
                    required property string name
                    required property string realName
                    required property string icon

                    readonly property string userName: name
                    readonly property string displayName: realName !== "" ? realName : name
                    readonly property bool current: ListView.isCurrentItem

                    width: panel.cellWidth
                    height: userList.height

                    Avatar {
                        theme: panel.theme
                        anchors.centerIn: parent
                        size: panel.avatarSize
                        source: cell.icon
                        scale: cell.current ? 1 : 0.62
                        opacity: cell.current ? 1 : 0.55
                        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                        Behavior on opacity { NumberAnimation { duration: 220 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            userList.currentIndex = cell.index
                            panel.focusInput()
                        }
                    }
                }
            }

            Avatar {
                theme: panel.theme
                anchors.centerIn: parent
                size: panel.avatarSize
                visible: !panel.listVisible
            }
        }

        // --- Name -----------------------------------------------------------
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: panel.width
            text: panel.manualUser ? theme.s.manualUser : panel.selectedDisplayName
            color: theme.text
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            font.family: theme.fontFamily
            font.pixelSize: Math.round(theme.fontBase * 1.5)
            font.weight: Font.Medium
            Layout.bottomMargin: theme.px(10)
        }

        // --- Eingabefelder --------------------------------------------------
        PillField {
            id: userBox
            theme: panel.theme
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: theme.px(340)
            visible: panel.manualUser
            placeholderText: theme.s.username
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            onAccepted: passwordBox.forceActiveFocus()
        }

        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: theme.px(340)
            Layout.preferredHeight: theme.px(46)

            PillField {
                id: passwordBox
                objectName: "passwordField"
                theme: panel.theme
                anchors.fill: parent
                echoMode: TextInput.Password
                passwordCharacter: theme.passwordCharacter
                placeholderText: theme.s.password
                focus: true
                inputMethodHints: Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                onAccepted: panel.startLogin()
                onTextChanged: if (text.length > 0) panel.message = ""

                Keys.onEscapePressed: clear()
                Keys.onLeftPressed: event => {
                    if (text === "" && panel.listVisible) userList.decrementCurrentIndex()
                    else event.accepted = false
                }
                Keys.onRightPressed: event => {
                    if (text === "" && panel.listVisible) userList.incrementCurrentIndex()
                    else event.accepted = false
                }
            }

            // Anmelde-Pfeil, erscheint neben dem Feld sobald etwas eingegeben wurde.
            AbstractButton {
                id: loginButton
                anchors.left: parent.right
                anchors.leftMargin: theme.px(14)
                width: theme.px(46)
                height: theme.px(46)
                hoverEnabled: true
                enabled: passwordBox.text.length > 0
                opacity: enabled ? (hovered ? 1 : 0.85) : 0
                Behavior on opacity { NumberAnimation { duration: 120 } }
                Accessible.name: theme.s.login
                onClicked: panel.startLogin()

                background: null
                contentItem: Image {
                    source: Qt.resolvedUrl("../assets/login.svgz")
                    sourceSize: Qt.size(panel.theme.px(92), panel.theme.px(92))
                    smooth: true
                    scale: loginButton.pressed ? 0.92 : 1
                }
            }
        }

        // --- Statusmeldung --------------------------------------------------
        Text {
            id: status
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: panel.width
            Layout.preferredHeight: theme.px(28)
            readonly property bool caps: keyboard.capsLock
            text: panel.message !== "" ? panel.message : (caps ? theme.s.capsLock : "")
            color: panel.message !== "" ? theme.errorColor : theme.text
            opacity: text !== "" ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            font.family: theme.fontFamily
            font.pixelSize: theme.fontBase
        }
    }

    SequentialAnimation {
        id: shake
        NumberAnimation { target: shakeOffset; property: "x"; to: -theme.px(14); duration: 45 }
        NumberAnimation { target: shakeOffset; property: "x"; to: theme.px(14); duration: 70 }
        NumberAnimation { target: shakeOffset; property: "x"; to: -theme.px(9); duration: 60 }
        NumberAnimation { target: shakeOffset; property: "x"; to: theme.px(9); duration: 60 }
        NumberAnimation { target: shakeOffset; property: "x"; to: 0; duration: 45 }
    }
}
