#  generate.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/sh

BASE_DIR=$(dirname "$0")
PROJECT_DIR="$(pwd)"

printf "\nExecuting SwiftGen from ${PROJECT_DIR}\n"

${PODS_ROOT}/SwiftGen/bin/swiftgen config run --config $BASE_DIR/swiftgen.yml

echo "Generating resources done successfully!"
