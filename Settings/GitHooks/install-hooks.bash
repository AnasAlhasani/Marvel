#  install-hooks.bash
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/usr/bin/env bash

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing git hooks..."
if [ -f $GIT_DIR/hooks/pre-commit ]; then
    echo "pre-commit hook is already installed"
else
    ln -sf ../../Settings/GitHooks/pre-commit.bash $GIT_DIR/hooks/pre-commit
    echo "installing hooks finished successfully!"
fi
