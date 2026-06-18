import QtQuick
import Quickshell
import qs.modules.common
import qs.modules.panel.waffle.looks

WPopupToolTip {
    anchorEdges: Config.options.panel.tools[Config.panelFamilyIndexWAFFLE].bar.config.bar.bottom ? Edges.Top : Edges.Bottom
}
