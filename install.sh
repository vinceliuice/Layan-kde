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

[[ ! -d ${AURORAE_DIR} ]] && mkdir -p ${AURORAE_DIR}
[[ ! -d ${SCHEMES_DIR} ]] && mkdir -p ${SCHEMES_DIR}
[[ ! -d ${PLASMA_DIR} ]] && mkdir -p ${PLASMA_DIR}
[[ ! -d ${LOOKFEEL_DIR} ]] && mkdir -p ${LOOKFEEL_DIR}
[[ ! -d ${KVANTUM_DIR} ]] && mkdir -p ${KVANTUM_DIR}
[[ ! -d ${WALLPAPER_DIR} ]] && mkdir -p ${WALLPAPER_DIR}

install() {
  local name=${1}
  local color=${2}

  [[ ${color} == '-light' ]] && local ELSE_COLOR='Light'

  [[ -d ${AURORAE_DIR}/${name}${color} ]] && rm -rf ${AURORAE_DIR}/${name}*
  [[ -d ${PLASMA_DIR}/${name}${color} ]] && rm -rf ${PLASMA_DIR}/${name}${color}
  [[ -f ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors ]] && rm -rf ${SCHEMES_DIR}/${name}${ELSE_COLOR}.colors
  [[ -d ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color} ]] && rm -rf ${LOOKFEEL_DIR}/com.github.vinceliuice.${name}${color}
  [[ -d ${KVANTUM_DIR}/${name} ]] && rm -rf ${KVANTUM_DIR}/${name}*
  [[ -d ${WALLPAPER_DIR}/${name}${color} ]] && rm -rf ${WALLPAPER_DIR}/${name}${color}

  cp -rf ${SRC_DIR}/aurorae/themes/${name}*                                           ${AURORAE_DIR}
  cp -rf ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${SCHEMES_DIR}
  cp -rf ${SRC_DIR}/Kvantum/${name}*                                                  ${KVANTUM_DIR}
  cp -rf ${SRC_DIR}/plasma/desktoptheme/common                                        ${PLASMA_DIR}/${name}${color}
  cp -rf ${SRC_DIR}/plasma/desktoptheme/${name}${color}/*                             ${PLASMA_DIR}/${name}${color}
  cp -rf ${SRC_DIR}/color-schemes/${name}${ELSE_COLOR}.colors                         ${PLASMA_DIR}/${name}${color}/colors
  cp -rf ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}${color}       ${LOOKFEEL_DIR}
  cp -rf ${SRC_DIR}/wallpaper/${name}${color}                                         ${WALLPAPER_DIR}
}

echo "Installing '${THEME_NAME} kde themes'..."

for color in "${colors[@]:-${COLOR_VARIANTS[@]}}"; do
  install "${name:-${THEME_NAME}}" "${color}"
done

echo "Install finished..."
