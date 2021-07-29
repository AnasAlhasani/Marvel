#  pre-commit.sh
#  Marvel
#
#  Created by Anas Alhasani on 13/05/2021.
#  Copyright © 2021 Anas Alhasani. All rights reserved.

#!/bin/sh

PROJECT_DIR="$(pwd)"
SETTINGS_DIR=$PROJECT_DIR/Settings

sh $SETTINGS_DIR/SwiftFormat/format.sh
