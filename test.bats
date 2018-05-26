#!/usr/bin/env bats


setup() {
    export SLS_DEBUG=t
    if ! [ -z "$CI" ]; then
        export LC_ALL=C.UTF-8
        export LANG=C.UTF-8
    fi
}

teardown() {
    rm -rf puck puck2 puck3 node_modules lambda package.zip .requirements-cache
    if [ -f serverless.yml.bak ]; then mv serverless.yml.bak serverless.yml; fi
}

@test "py3.6 can package flask with default options" {
    cd tests/base
    npm i $(npm pack ../..)
    npm link
    lambda-python-requirements --dockerizePip
    ls pal/flask
}

@test "py3.6 can package flask with zip option" {
    cd tests/base
    npm i $(npm pack ../..)
    npm link
    lambda-python-requirements --zip --dockerizePip
    unzip package.zip -d puck
    ls package.zip
    ls puck/flask
}

@test "py3.6 doesn't package boto3 by default" {
    cd tests/base
    npm i $(npm pack ../..)
    npm link
    lambda-python-requirements --dockerizePip
    ! ls pal/boto3
}

@test "pipenv py3.6 can package flask with default options" {
    cd tests/pipenv
    npm i $(npm pack ../..)
    lambda-python-requirements --usePipenv --dockerizePip
    ls pal/flask
}

@test "pipenv py3.6 can package flask with zip option" {
    cd tests/pipenv
    npm i $(npm pack ../..)
    lambda-python-requirements --zip --usePipenv --dockerizePip
    unzip package.zip -d puck
    ls package.zip
}

@test "pipenv py3.6 doesn't package boto3 by default" {
    cd tests/pipenv
    npm i $(npm pack ../..)
    lambda-python-requirements --usePipenv --dockerizePip
    ! ls pal/boto3
}
