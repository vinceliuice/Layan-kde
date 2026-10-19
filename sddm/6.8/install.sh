#!/usr/bin/env bash
# Layan SDDM theme (Qt 6) installer
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="${DESTDIR:-}/usr/share/sddm/themes"
CONF_DIR="${DESTDIR:-}/etc/sddm.conf.d"
VARIANTS=(Layan Layan-light)
ACTION=install
ACTIVATE=""

usage() {
  cat <<USAGE
Usage: sudo ./install.sh [options]

  -v, --variant <dark|light|all>   Which variant to install (default: all)
  -a, --activate                   Set the installed theme as current SDDM theme
                                   (writes ${CONF_DIR#"${DESTDIR:-}"}/10-layan.conf; with 'all' -> Layan)
  -d, --dest <dir>                 Theme directory (default: ${THEME_DIR#"${DESTDIR:-}"})
  -u, --uninstall                  Remove the theme(s)
  -h, --help                       Show this help

Environment: DESTDIR=<dir> prefixes all paths (for packaging).
USAGE
}

info() { printf '\033[1;36m::\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m::\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mError:\033[0m %s\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--variant)
      [[ $# -ge 2 ]] || die "$1 needs an argument"
      case "$2" in
        dark|Layan)        VARIANTS=(Layan) ;;
        light|Layan-light) VARIANTS=(Layan-light) ;;
        all)               VARIANTS=(Layan Layan-light) ;;
        *) die "unknown variant '$2' (dark, light, all)" ;;
      esac
      shift 2 ;;
    -a|--activate)  ACTIVATE=1; shift ;;
    -d|--dest)      [[ $# -ge 2 ]] || die "$1 needs an argument"; THEME_DIR="$2"; shift 2 ;;
    -u|--uninstall) ACTION=uninstall; shift ;;
    -h|--help)      usage; exit 0 ;;
    *) usage >&2; die "unknown option '$1'" ;;
  esac
done

# Re-run via sudo when not root (no password handling in this script).
if [[ $EUID -ne 0 && -z "${DESTDIR:-}" && "$THEME_DIR" == /usr/* ]]; then
  info "Root privileges required, re-running with sudo ..."
  exec sudo -- "$0" "$@"
fi

if [[ $ACTION == uninstall ]]; then
  for v in "${VARIANTS[@]}"; do
    info "Removing $THEME_DIR/$v"
    rm -rf -- "${THEME_DIR:?}/$v"
  done
  ok "Done."
  exit 0
fi

[[ -d $SRC/common ]] || die "common/ not found next to install.sh"

for v in "${VARIANTS[@]}"; do
  [[ -d $SRC/$v ]] || die "variant directory '$v' not found"
  target="$THEME_DIR/$v"
  info "Installing $v -> $target"
  rm -rf -- "$target"
  mkdir -p -- "$target"
  # shared QML first, then variant-specific files (config, background, icons)
  cp -r -- "$SRC/common/." "$target/"
  cp -r -- "$SRC/$v/." "$target/"
  find "$target" -type d -exec chmod 755 {} +
  find "$target" -type f -exec chmod 644 {} +
done

if [[ -n $ACTIVATE ]]; then
  current="${VARIANTS[0]}"
  mkdir -p -- "$CONF_DIR"
  printf '[Theme]\nCurrent=%s\n' "$current" > "$CONF_DIR/10-layan.conf"
  ok "SDDM theme set to $current ($CONF_DIR/10-layan.conf)"
fi

ok "Done. Test with:  sddm-greeter-qt6 --test-mode --theme $THEME_DIR/${VARIANTS[0]}"
