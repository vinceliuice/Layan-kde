#!/bin/bash

SRC_DIR=$(cd $(dirname $0) && pwd)

AURORAE_DIR="$HOME/.local/share/aurorae/themes"
SCHEMES_DIR="$HOME/.local/share/color-schemes"
PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
KVANTUM_DIR="$HOME/.config/Kvantum"

THEME_NAME=Layan

install() {
  local name=${1}

  local AURORAE_THEME="${AURORAE_DIR}/${name}"
  local PLASMA_THEME="${PLASMA_DIR}/${name}"
  local LOOKFEEL_THEME="${LOOKFEEL_DIR}/com.github.vinceliuice.${name}"

  [[ -d ${AURORAE_THEME} ]] && rm -rf ${AURORAE_THEME}
  [[ -d ${PLASMA_THEME} ]] && rm -rf ${PLASMA_THEME}
  [[ -d ${LOOKFEEL_THEME} ]] && rm -rf ${LOOKFEEL_THEME}
  [[ -d ${KVANTUM_THEME}/${name} ]] && rm -rf ${KVANTUM_THEME}/${name}
  [[ -d ${SCHEMES_DIR}/${name}.colors ]] && rm -rf ${SCHEMES_DIR}/${name}.colors

  mkdir -p                                                                           ${AURORAE_DIR}
  mkdir -p                                                                           ${SCHEMES_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}
  mkdir -p                                                                           ${LOOKFEEL_DIR}
  mkdir -p                                                                           ${KVANTUM_DIR}
  mkdir -p                                                                           ${WALLPAPER_DIR}/Matcha

  cp -ur ${SRC_DIR}/aurorae/themes/${name}                                           ${AURORAE_DIR}
  cp -ur ${SRC_DIR}/color-schemes/*.colors                                           ${SCHEMES_DIR}
  cp -ur ${SRC_DIR}/Kvantum/*                                                        ${KVANTUM_DIR}
  cp -ur ${SRC_DIR}/plasma/desktoptheme/${name}${ELSE_DARK}                          ${PLASMA_DIR}
  cp -ur ${SRC_DIR}/color-schemes/Layan.colors                                        ${PLASMA_DIR}/${name}/colors
  cp -ur ${SRC_DIR}/plasma/look-and-feel/com.github.vinceliuice.${name}              ${LOOKFEEL_DIR}
}

echo "Installing '${THEME_NAME} kde themes'..."

install "${name:-${THEME_NAME}}"

echo "Install finished..."
