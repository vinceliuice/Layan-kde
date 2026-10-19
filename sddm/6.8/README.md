# Layan SDDM theme (Qt 6)

Layan for SDDM, rewritten from scratch for Qt 6 / Plasma 6.x (tested design target: Plasma 6.8).

The old theme was a fork of Plasma's Breeze greeter and imported `org.kde.breeze.components`,
`org.kde.plasma.plasma5support`, `org.kde.kirigami` and `Qt5Compat.GraphicalEffects`.
Those modules are private to Plasma and change or disappear between releases, which is why the theme broke
(`VirtualKeyboardLoader is not a type` -> fallback to the embedded theme).

This version has **no KDE dependencies**. It only uses modules that ship with Qt itself:

| Module | Used for |
| --- | --- |
| `QtQuick`, `QtQuick.Layouts` | layout, animation |
| `QtQuick.Controls.Basic` | text fields, buttons, menus (explicit style, independent of the system style) |
| `QtQuick.Effects` (`MultiEffect`) | avatar mask, shadow, optional background blur |
| `QtQuick.VirtualKeyboard` | optional on-screen keyboard (button is hidden if the module is missing) |

Requirements: **Qt >= 6.5**, **SDDM >= 0.21** (Qt 6 greeter).

## Features

- Clock/date (locale aware), user list with avatars (arrow keys / click), "Other..." for manual user name
- Password field with Caps Lock hint, shake animation and error message on failed login
- Sleep / Restart / Shut Down (buttons are disabled when the action is not available)
- Session and keyboard layout selector, optional on-screen keyboard, optional host name
- Scales with the screen height (also works on portrait displays and 4K without Qt scaling)
- English, German, French and Spanish texts (`common/components/Strings.qml`, easy to extend)
- Dark (`Layan`) and light (`Layan-light`) variant

## Installation

```sh
sudo ./install.sh                 # installs Layan and Layan-light
sudo ./install.sh -v dark -a      # only the dark variant and set it as current SDDM theme
sudo ./install.sh --uninstall
```

`-a` writes `/etc/sddm.conf.d/10-layan.conf`. Alternatively use *System Settings -> Login Screen (SDDM)*.

Layout of this repository: `common/` contains the QML shared by both variants; `Layan/` and `Layan-light/`
contain only the variant specific files (`theme.conf`, `metadata.desktop`, background, icons, preview).
`install.sh` merges them into `/usr/share/sddm/themes/<variant>/`.

## Test

```sh
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/Layan
```

## Configuration

Edit `theme.conf` in the installed theme folder, or put overrides into `theme.conf.user` next to it.

| Key | Default (dark) | Meaning |
| --- | --- | --- |
| `background` | `background.jpg` | Image (relative to the theme or absolute path); empty = only `fallbackColor` |
| `fallbackColor` | `#25252d` | Color shown behind/without the image |
| `blur` | `0` | Background blur, `0.0` - `1.0` |
| `dim` | `0` | Darken the background, `0.0` - `1.0` |
| `accentColor` / `accentTextColor` | `#5657f5` / `#ffffff` | Input field and highlight colors |
| `textColor` | `#ffffff` | Clock, labels |
| `errorColor` | `#ff7b7b` | Failed login message |
| `panelColor` / `panelTextColor` | `#2b2b36` / `#ffffff` | Popup menus |
| `fontFamily` | system font | |
| `fontSize` | `10` | Base size in pt for all labels |
| `clockSize` | `132` | Clock size (px at 1080p) |
| `showClock`, `showDate`, `showHostname` | `true`, `true`, `false` | |
| `virtualKeyboard` | `true` | Show the on-screen keyboard button if `QtQuick.VirtualKeyboard` is installed |
| `loginOnAllScreens` | `false` | `false`: login, session/layout selector and on-screen keyboard only on the primary screen (the only one that receives keyboard focus); other screens show clock and power buttons |
| `timeFormat`, `dateFormat` | *(empty)* | Qt format strings, e.g. `HH:mm`, `dddd, d. MMMM yyyy`; empty = locale default |
| `passwordCharacter` | `●` | |

For the on-screen keyboard SDDM must run the greeter with `InputMethod=qtvirtualkeyboard`
(`/etc/sddm.conf.d/virtualkbd.conf`, section `[General]`).

## Notes

- Without a GPU (software rendering, e.g. some VMs) shader effects are unavailable: the avatar is then
  shown as a square image without shadow, everything else works.
- SDDM starts one greeter view per screen, but only the primary one gets keyboard focus. By default the login UI is therefore shown on the primary screen only (`loginOnAllScreens`).

## License

CC-BY-SA, original artwork and icons by Vince Liuice (Layan-kde).
