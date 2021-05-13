#  swiftlint.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/bash

set -e
    
function validate_result() {
    if [ "$RESULT" == '' ]; then
        printf "SwiftLint Finished.\n"
    else
        echo ""
        printf "SwiftLint Failed. Please check below:\n"

        while read -r line; do
            FILEPATH=$(echo $line | cut -d : -f 1)
            L=$(echo $line | cut -d : -f 2)
            C=$(echo $line | cut -d : -f 3)
            TYPE=$(echo $line | cut -d : -f 4 | cut -c 2-)
            MESSAGE=$(echo $line | cut -d : -f 5 | cut -c 2-)
            DESCRIPTION=$(echo $line | cut -d : -f 6 | cut -c 2-)
            printf "\n $TYPE\n"
            printf "    $FILEPATH:$L:$C\n"
            printf "    $MESSAGE - $DESCRIPTION\n"
        done <<< "$RESULT"

        printf "\nCOMMIT ABORTED. Please fix them before commiting.\n"

        exit 1
    fi
}

BASEDIR=$(dirname "$0")
EXECUTION_DIRECTORY="$(pwd)"
export SRCROOT="$(pwd)"
export PODS_ROOT=$SRCROOT/Pods

printf "\nExecuting SwiftLint from ${EXECUTION_DIRECTORY}\n"
LINT_COMMAND="${PODS_ROOT}/SwiftLint/swiftlint lint --config "$BASEDIR/.swiftlint.yml" --quiet --force-exclude || true;"

if [ "$STRICT" == false ]; then
    eval $LINT_COMMAND
    echo "SwiftLint done successfully!"
else
    RESULT=$(eval $LINT_COMMAND)
    validate_result
fi
