#!/bin/bash

scriptDir=tools/scripts

./"$scriptDir"/copyLocalConfig.sh
./"$scriptDir"/repairSubmodules.sh

# git add .