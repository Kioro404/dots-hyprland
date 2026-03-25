import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.panel.waffle.looks
import qs.modules.panel.waffle.actionCenter

ActionCenterToggle {
    id: root

    name: Network.ethernet ? Translation.tr("Network") : Network.networkName


}
