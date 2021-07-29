#  swiftlint.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/sh

BASE_DIR=$(dirname "$0")
PROJECT_DIR="$(pwd)"
PODS_ROOT=$PROJECT_DIR/Pods

printf "\nExecuting SwiftLint from ${PROJECT_DIR}\n"

${PODS_ROOT}/SwiftLint/swiftlint lint --config "$BASE_DIR/.swiftlint.yml" --quiet --force-exclude || true;

echo "SwiftLint done successfully!"
