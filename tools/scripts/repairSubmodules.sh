#!/bin/bash

git submodule deinit -f dots/default/.config/quickshell/ii/modules/common/widgets/shapes
rm -rf .git/modules/dots/default/.config/quickshell/ii/modules/common/widgets/shapes
git submodule update --init --recursive