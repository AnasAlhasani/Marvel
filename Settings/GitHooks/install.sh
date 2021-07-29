#  install.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/sh

BASE_DIR=$(dirname "$0")
GIT_DIR=$(git rev-parse --git-dir)

HOOK_LIST=(
    pre-commit
)

printf "\nInstalling git hooks in ${GIT_DIR}\n"

for HOOK in "${HOOK_LIST[@]}"; do
    if [ -f $GIT_DIR/hooks/$HOOK ]; then
        echo "Skipped the hook: $HOOK"
    else
        echo "Installing the hook: $HOOK"
        ln -sf $BASE_DIR/$HOOK.sh $GIT_DIR/hooks/$HOOK
    fi
done

echo "Marvel git-hooks installed"
