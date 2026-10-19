import QtQuick

// Minimale Übersetzungstabelle. Neue Sprache = neuer Block in `table`.
QtObject {
    readonly property string lang: Qt.locale().name.substring(0, 2)

    readonly property var table: ({
        "en": {
            password: "Password", username: "Username", login: "Log in",
            loginFailed: "Login failed", capsLock: "Caps Lock is on",
            sleep: "Sleep", restart: "Restart", shutdown: "Shut Down",
            other: "Other…", listUsers: "List Users",
            session: "Session", keyboard: "Keyboard Layout",
            virtualKeyboard: "Virtual Keyboard", manualUser: "Type in username and password"
        },
        "de": {
            password: "Passwort", username: "Benutzername", login: "Anmelden",
            loginFailed: "Anmeldung fehlgeschlagen", capsLock: "Feststelltaste ist aktiv",
            sleep: "Ruhezustand", restart: "Neustart", shutdown: "Herunterfahren",
            other: "Anderer…", listUsers: "Benutzerliste",
            session: "Sitzung", keyboard: "Tastaturlayout",
            virtualKeyboard: "Bildschirmtastatur", manualUser: "Benutzername und Passwort eingeben"
        },
        "fr": {
            password: "Mot de passe", username: "Nom d’utilisateur", login: "Se connecter",
            loginFailed: "Échec de la connexion", capsLock: "Verrouillage majuscules activé",
            sleep: "Veille", restart: "Redémarrer", shutdown: "Éteindre",
            other: "Autre…", listUsers: "Liste des utilisateurs",
            session: "Session", keyboard: "Disposition du clavier",
            virtualKeyboard: "Clavier virtuel", manualUser: "Saisir identifiant et mot de passe"
        },
        "es": {
            password: "Contraseña", username: "Usuario", login: "Iniciar sesión",
            loginFailed: "Error al iniciar sesión", capsLock: "Bloq Mayús activado",
            sleep: "Suspender", restart: "Reiniciar", shutdown: "Apagar",
            other: "Otro…", listUsers: "Lista de usuarios",
            session: "Sesión", keyboard: "Distribución del teclado",
            virtualKeyboard: "Teclado virtual", manualUser: "Introduzca usuario y contraseña"
        }
    })

    function t(key) {
        const l = table[lang] || table["en"]
        return l[key] !== undefined ? l[key] : table["en"][key]
    }

    readonly property string password: t("password")
    readonly property string username: t("username")
    readonly property string login: t("login")
    readonly property string loginFailed: t("loginFailed")
    readonly property string capsLock: t("capsLock")
    readonly property string sleep: t("sleep")
    readonly property string restart: t("restart")
    readonly property string shutdown: t("shutdown")
    readonly property string other: t("other")
    readonly property string listUsers: t("listUsers")
    readonly property string session: t("session")
    readonly property string keyboard: t("keyboard")
    readonly property string virtualKeyboard: t("virtualKeyboard")
    readonly property string manualUser: t("manualUser")
}
