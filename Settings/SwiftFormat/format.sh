#  format.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/sh

BASE_DIR=$(dirname "$0")
PROJECT_DIR="$(pwd)"
PODS_ROOT=$PROJECT_DIR/Pods

printf "\nExecuting SwiftFormat from ${PROJECT_DIR}\n"
    
git diff --diff-filter=d --staged --name-only | grep -e '\.swift$' | while read FILE; do
    ${PODS_ROOT}/SwiftFormat/CommandLineTool/swiftformat . --config $BASE_DIR/.swiftformat --quiet "${FILE}";
    git add "$FILE";
done
    
echo "SwiftFormat done successfully!"
