#!/bin/bash

# ./scripts/bump-version.sh <new version>
# eg ./scripts/bump-version.sh "3.0.0-alpha.1"

set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR/..

NEW_VERSION="$1"

FILE_FILEPATH="package.json"

perl -pi -e "s/\"version\": \"[^\"]+\",/\"version\": \"$NEW_VERSION\",/g" $FILE_FILEPATH
