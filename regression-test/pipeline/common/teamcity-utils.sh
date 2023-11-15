#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#!/bin/bash

get_running_build() {
    echo "获取pr在某条流水线上正在跑的build"
}

get_queue_build() {
    echo "获取pr在某条流水线上排队的build"
}

add_build() {
    echo "新触发一个build"
}

cancel_running_build() {
    echo "cancel_running_build"
}

cancel_queue_build() {
    echo "cancel_queue_build"
}

skip_build() {
    echo "对于不需要跑流水线的pr, 直接回复github成功"
}
