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

# github中评论的要触发的流水线名字
# 到
# teamcity流水线实际的名称
# 的映射
# 新加流水线需要修改这里
declare -A comment_to_pipeline
comment_to_pipeline=(
    ['feut']='Doris_Doris_FeUt'
    ['beut']='Doris_DorisBeUt_BeUt'
    ['compile']='Doris_DorisCompile_Compile'
    ['p0']='Doris_DorisRegression_P0Regression'
    ['p1']='Doris_DorisRegression_P1Regression'
    ['external']='Doris_External_Regression'
    ['clickbench']='Doris_Performance_Clickbench_ClickbenchNew'
    ['pipelinex_p0']='Doris_DorisRegression_P0RegressionPipelineX'
    ['arm']='Doris_ArmPipeline_P0Regression'
    ['tpch']='Tpch_TpchSf100'
)

# github中评论的要触发的流水线名字
# 到
# teamcity流水线返回结果给github的名称
# 的映射
# 新加流水线需要修改这里
declare -A conment_to_context
conment_to_context=(
    ['compile']='COMPILE (DORIS_COMPILE)'
    ['feut']='FE UT (Doris FE UT)'
    ['beut']='BE UT (Doris BE UT)'
    ['p0']='P0 Regression (Doris Regression)'
    ['p1']='P1 Regression (Doris Regression)'
    ['external']='External Regression (Doris External Regression)'
    ['pipelinex_p0']='P0 Regression PipelineX (Doris Regression)'
    ['clickbench']='clickbench-new (clickbench)'
    ['arm']='P0 Regression (ARM pipeline)'
    ['tpch']='tpch-sf100 (tpch)'
)

get_commit_id_of_build() {
    # 获取某个build的commit id
    if [[ -z "$1" ]]; then return 1; fi
    build_id="$1"
    if ret=$(
        curl -s -X GET \
            -u OneMoreChance:OneMoreChance \
            -H "Content-Type:text/plain" \
            -H "Accept: application/json" \
            "http://43.132.222.7:8111/app/rest/builds/${build_id}"
    ); then
        commit_id=$(echo "${ret}" | jq -r '.revisions.revision[0].version')
        echo "${commit_id}"
    else
        return 1
    fi
}

get_running_build_of_pr() {
    # "获取pr在某条流水线上正在跑的build"
    if [[ -z "${PIPELINE}" || -z "${PULL_REQUEST_NUM}" ]]; then
        echo "ERROR: env PIPELINE or PULL_REQUEST_NUM not set."
        return 1
    fi
    local running_builds_list
    if ret=$(
        curl -s -X GET \
            -u OneMoreChance:OneMoreChance \
            -H "Content-Type:text/plain" \
            -H "Accept: application/json" \
            "http://43.132.222.7:8111/app/rest/builds?locator=buildType:${PIPELINE},branch:pull/${PULL_REQUEST_NUM},running:true"
    ); then
        running_builds_list=$(echo "${ret}" | jq -r '.build[].id')
        echo "${running_builds_list}"
    else
        return 1
    fi
}

get_queue_build_of_pr() {
    # "获取pr在某条流水线上排队的build"
    local queue_builds_list
    if ret=$(
        curl -s -X GET \
            -u OneMoreChance:OneMoreChance \
            -H "Content-Type:text/plain" \
            -H "Accept: application/json" \
            "http://43.132.222.7:8111/app/rest/buildQueue?locator=buildType:${PIPELINE}"
    ); then
        queue_builds_list=$(echo "${ret}" | jq ".build[] | select(.branchName == \"pull/${PULL_REQUEST_NUM}\") | .id")
        echo "${queue_builds_list}"
    else
        return 1
    fi
}

# get_queue_build_of_pr "$1" "$2"

add_build() {
    # 新触发一个build
    if [[ -z "$2" ]]; then
        echo "Usage: add_build PIPELINE PULL_REQUEST_NUM [COMMENT_REPEAT_TIMES]"
        return 1
    fi
    PULL_REQUEST_NUM="$1"
    COMMENT_TRIGGER_TYPE="$2"
    COMMENT_REPEAT_TIMES="$3"

    if [[ -z "${COMMIT_ID_FROM_TRIGGER}" ]]; then
        echo "WARNINR: env COMMIT_ID_FROM_TRIGGER not set"
    fi
    local PIPELINE
    PIPELINE="${comment_to_pipeline[${COMMENT_TRIGGER_TYPE}]}"
    if ret=$(
        curl -s -X POST \
            -u OneMoreChance:OneMoreChance \
            -H "Content-Type:text/plain" \
            -H "Accept: application/json" \
            "http://43.132.222.7:8111/httpAuth/action.html?add2Queue=${PIPELINE}&branchName=pull/${PULL_REQUEST_NUM}&name=env.commit_id_from_trigger\&value=${COMMIT_ID_FROM_TRIGGER:-}&name=env.repeat_times&value=${COMMENT_REPEAT_TIMES:-1}"
    ); then
        echo "INFO: Add new build to PIPELINE ${PIPELINE} of PR ${PULL_REQUEST_NUM} with COMMENT_REPEAT_TIMES ${COMMENT_REPEAT_TIMES:-1}"
    else
        return 1
    fi
}

cancel_running_build() {
    echo "TODO: cancel_running_build"
}

cancel_queue_build() {
    echo "TODO: cancel_queue_build"
}

function skip_build() {
    # 对于不需要跑teamcity pipeline的PR，直接调用github的接口返回成功
    if [[ -z "${GITHUB_TOKEN}" ]]; then
        echo "ERROR: env GITHUB_TOKEN not set"
        return 1
    fi
    if [[ -z "$2" ]]; then
        echo "Usage: skip_teamcity_pipeline PR_COMMIT_ID COMMENT_TRIGGER_TYPE"
        return 1
    fi
    PR_COMMIT_ID="$1"
    COMMENT_TRIGGER_TYPE="$2"

    local state="${TC_BUILD_STATE:-success}" # 可选值 success failure pending
    payload="{\"state\":\"${state}\",\"target_url\":\"\",\"description\":\"Skip teamCity build\",\"context\":\"${conment_to_context[${COMMENT_TRIGGER_TYPE}]}\"}"
    if curl -L \
        -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${GITHUB_TOKEN:-}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "https://api.github.com/repos/apache/doris/statuses/${PR_COMMIT_ID:-}" \
        -d "${payload}"; then
        echo "INFO: Skipped ${PR_COMMIT_ID} ${COMMENT_TRIGGER_TYPE}"
    else
        return 1
    fi
}

# GITHUB_TOKEN=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
# skip_teamcity_pipeline '9940812522228f574c5b630666189bc0aa4b1c60' clickbench

cancel_and_add_build() {
    echo "try to cancel queue or running build first, then add build"
}
