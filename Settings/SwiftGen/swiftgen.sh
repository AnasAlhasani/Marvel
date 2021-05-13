#  swiftgen.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/bash

BASEDIR=$(dirname "$0")
EXECUTION_DIR="$(pwd)"

printf "\nExecuting SwiftGen from ${EXECUTION_DIR}\n"

${PODS_ROOT}/SwiftGen/bin/swiftgen config run --config $BASEDIR/swiftgen.yml

echo "Generating resources done successfully!"
