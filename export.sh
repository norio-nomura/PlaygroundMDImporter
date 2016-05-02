#!/bin/sh

GIT_TAG=`git tag --contains`
[ -z "${GIT_TAG}" ] && exit 0
BUILD_DIR=`dirname $0`/build

PRODUCT_NAME=PlaygroundMDImporter
ARCHIVE=${BUILD_DIR}/${PRODUCT_NAME}-${GIT_TAG}.xcarchive
IDENTITY_APPLICATION="Developer ID Application: Norio Nomura"

# ARCHIVE
xcodebuild -project ${PRODUCT_NAME}.xcodeproj \
  -scheme ${PRODUCT_NAME} archive \
  -archivePath "${ARCHIVE}" | xcpretty

# PACKAGE
FULL_PRODUCT_NAME=Playground.mdimporter
INSTALL_PATH="/Library/Spotlight"
COMPONENT=${ARCHIVE}/Products${INSTALL_PATH}/${FULL_PRODUCT_NAME}
IDENTIFIER="io.github.norio-nomura.PlaygroundMDImporter"
REQUIREMENTS_PLIST=`dirname $0`/def.plist
IDENTITY_INSTALLER="Developer ID Installer: Norio Nomura"
PACKAGE=${BUILD_DIR}/${FULL_PRODUCT_NAME}-${GIT_TAG}.pkg

productbuild --component "${COMPONENT}" "${INSTALL_PATH}" \
  --identifier "${IDENTIFIER}" \
  --product "${REQUIREMENTS_PLIST}" \
  --sign "${IDENTITY_INSTALLER}" "${PACKAGE}"

shasum -a 256 "${PACKAGE}"

# zip
ZIP=${BUILD_DIR}/${FULL_PRODUCT_NAME}-${GIT_TAG}.zip
(cd "${ARCHIVE}/Products${INSTALL_PATH}"; zip --symlinks -r - "${FULL_PRODUCT_NAME}") > "${ZIP}"
shasum -a 256 "${ZIP}"
