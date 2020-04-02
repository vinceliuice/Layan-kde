#!/bin/bash

ROOT_UID=0
DEST_DIR=

# Destination directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  AURORAE_DIR="/usr/share/aurorae/themes"
  SCHEMES_DIR="/usr/share/color-schemes"
  PLASMA_DIR="/usr/share/plasma/desktoptheme"
  LOOKFEEL_DIR="/usr/share/plasma/look-and-feel"
  KVANTUM_DIR="/usr/share/Kvantum"
else
  AURORAE_DIR="$HOME/.local/share/aurorae/themes"
  SCHEMES_DIR="$HOME/.local/share/color-schemes"
  PLASMA_DIR="$HOME/.local/share/plasma/desktoptheme"
  LOOKFEEL_DIR="$HOME/.local/share/plasma/look-and-feel"
  KVANTUM_DIR="$HOME/.config/Kvantum"
fi

SRC_DIR=$(cd $(dirname $0) && pwd)

THEME_NAME=Layan

install() {
  local name=${1}

  mkdir -p                                                                           ${AURORAE_DIR}
  mkdir -p                                                                           ${SCHEMES_DIR}
  mkdir -p                                                                           ${PLASMA_DIR}
  mkdir -p                                                                           ${LOOKFEEL_DIR}
  mkdir -p                                                                           ${KVANTUM_DIR}

  cp -r ${SRC_DIR}/aurorae/themes/*                                                  ${AURORAE_DIR}
  cp -r ${SRC_DIR}/color-schemes/*.colors                                            ${SCHEMES_DIR}
  cp -r ${SRC_DIR}/Kvantum/*                                                         ${KVANTUM_DIR}
  cp -r ${SRC_DIR}/plasma/desktoptheme/*                                             ${PLASMA_DIR}
  cp -r ${SRC_DIR}/color-schemes/${name}.colors                                      ${PLASMA_DIR}/${name}/colors
  cp -r ${SRC_DIR}/color-schemes/${name}.colors                                      ${PLASMA_DIR}/${name}-solid/colors
  cp -r ${SRC_DIR}/plasma/look-and-feel/*                                            ${LOOKFEEL_DIR}
}

echo "Installing '${THEME_NAME} kde themes'..."

install "${name:-${THEME_NAME}}"

echo "Install finished..."
