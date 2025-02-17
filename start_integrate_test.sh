#
#  Licensed to the Apache Software Foundation (ASF) under one or more
#  contributor license agreements.  See the NOTICE file distributed with
#  this work for additional information regarding copyright ownership.
#  The ASF licenses this file to You under the Apache License, Version 2.0
#  (the "License"); you may not use this file except in compliance with
#  the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

#!/bin/bash

set -e
set -x

echo 'start integrate-test'

# set root workspace
ROOT_DIR=$(pwd)
echo "integrate-test root work-space -> ${ROOT_DIR}"

# show all github-env
echo "github current commit id  -> $2"
echo "github pull request branch -> ${GITHUB_REF}"
echo "github pull request slug -> ${GITHUB_REPOSITORY}"
echo "github pull request repo slug -> ${GITHUB_REPOSITORY}"
echo "github pull request actor -> ${GITHUB_ACTOR}"
echo "github pull request repo param -> $1"
echo "github pull request base branch -> $3"
echo "github pull request head branch -> ${GITHUB_HEAD_REF}"

echo "use dubbo-go-samples $3 branch for integration testing"
git clone -b main https://github.com/dubbo-go-pixiu/samples.git integrate_samples && cd integrate_samples

# update dubbo-go to current commit id
go mod edit -replace=github.com/apache/dubbo-go-pixiu=github.com/"$1"@"$2"

grep -rl "github.com/apache/dubbo-go-pixiu/pkg" | xargs sed -i 's/github.com\/apache\/dubbo-go-pixiu\/pkg\//github.com\/apache\/dubbo-go-pixiu\/pixiu\/pkg\//g'

# prepare dependency
go mod tidy

# start integrate test
./start_integrate_test.sh
