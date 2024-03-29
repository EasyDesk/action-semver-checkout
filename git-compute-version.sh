#!/bin/bash

IS_DEV_VERSION="true"
DESCRIBE_RES=`git describe --long --abbrev=8 --match 'v[0-9]*.[0-9]*.[0-9]*' 2> /dev/null`

if [[ $? != 0 ]] ; then
  COMMIT_DISTANCE=`git rev-list --count HEAD`
  COMMIT_HASH=`git log -n1 --format=%h`
  VERSION="0.1.0"
  MAJOR="0"
  MINOR="1"
  PATCH="0"
elif [[ "${DESCRIBE_RES}" =~ ^(.+)-(.+)-g(.+)$ ]] ; then
  echo "Git describe returned ${DESCRIBE_RES}"

  TAG=${BASH_REMATCH[1]}
  COMMIT_DISTANCE=${BASH_REMATCH[2]}
  COMMIT_HASH=${BASH_REMATCH[3]}

  if [[ "${TAG}" =~ ^v([1-9][0-9]*|0)\.([1-9][0-9]*|0)\.([1-9][0-9]*|0)$ ]] ; then
    MAJOR=${BASH_REMATCH[1]}
    MINOR=${BASH_REMATCH[2]}
    PATCH=${BASH_REMATCH[3]}
    VERSION="${MAJOR}.${MINOR}.${PATCH}"

    if [[ ${COMMIT_DISTANCE} == 0 ]] ; then
      IS_DEV_VERSION="false"
    fi
  else
    VERSION="${TAG}"
  fi
else
  echo "::error::Git describe returned an invalid description"
  exit 1
fi

COMPLETE_VERSION="${VERSION}"
if [[ ${IS_DEV_VERSION} == "true" ]] ; then
  PRERELEASE="dev.${COMMIT_DISTANCE}"
  BUILD="${COMMIT_HASH}"
  COMPLETE_VERSION="${VERSION}-${PRERELEASE}+${BUILD}"
fi

echo "Repository is now at version ${COMPLETE_VERSION} (dev version: ${IS_DEV_VERSION})"
if [[ ${IS_DEV_VERSION} == "true" ]] ; then
  echo "Current version is a dev-only version and shall not be released"
fi

echo "major=${MAJOR}" >> $GITHUB_OUTPUT
echo "minor=${MINOR}" >> $GITHUB_OUTPUT
echo "patch=${PATCH}" >> $GITHUB_OUTPUT
echo "version=v${COMPLETE_VERSION}" >> $GITHUB_OUTPUT
echo "prerelease=${PRERELEASE}" >> $GITHUB_OUTPUT
echo "build=${BUILD}" >> $GITHUB_OUTPUT
echo "version-without-v=${COMPLETE_VERSION}" >> $GITHUB_OUTPUT
echo "is-dev-version=${IS_DEV_VERSION}" >> $GITHUB_OUTPUT
