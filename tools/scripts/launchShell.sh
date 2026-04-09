#!/bin/bash
echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../dots/.config/quickshell/ii"
QT_LOGGING_RULES="qt.qml.propertyCache.append=false" quickshell -c "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../../dots/.config/quickshell/ii"
