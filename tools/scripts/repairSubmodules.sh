#!/bin/bash

git submodule deinit -f dots/.config/quickshell/ii/modules/common/widgets/shapes
rm -rf .git/modules/dots/.config/quickshell/ii/modules/common/widgets/shapes
git submodule update --init --recursive