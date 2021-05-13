#  pre-commit.bash
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/usr/bin/env bash

EXECUTION_DIR="$(pwd)"
SETTINGS=$EXECUTION_DIR/Settings

bash $SETTINGS/SwiftFormat/swiftformat.sh
STRICT=true bash $SETTINGS/SwiftLint/swiftlint.sh

if [ $? -ne 0 ]; then
    exit 1
fi
