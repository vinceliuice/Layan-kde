#!/bin/bash

ROOT_UID=0

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LAYOUT_DIR="/usr/share/plasma/layout-templates"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
  WALLPAPER_DIR="/usr/share/wallpapers"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LAYOUT_DIR="$HOME/.local/share/plasma/layout-templates"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
  WALLPAPER_DIR="$HOME/.local/share/wallpapers"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Layan
COLOR_VARIANTS=('' '-light')

uninstall() {
  local name=${1}
  local color=${2}

  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'

  [[ -d ${AURORAE_DIR}/${name}${color} ]] && rm -rfv ${AURORAE_DIR}/${name}*
  [[ -d ${PLASMA_DIR}/${name}${color} ]] && rm -rfv ${PLASMA_DIR}/${name}${color}
  [[ -f ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors ]] && rm -rfv ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors
  [[ -d ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color} ]] && rm -rfv ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}
  [[ -d ${KVANTUM_DIR}/${name} ]] && rm -rfv ${KVANTUM_DIR}/${name}*
  [[ -d ${WALLPAPER_DIR}/${name}${color} ]] && rm -rfv ${WALLPAPER_DIR}/${name}${color}
}

echo "Uninstalling '${THEME_NAME} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  uninstall "${name:-${THEME_NAME}}" "${color}"
done

echo "Uninstall finished..."
