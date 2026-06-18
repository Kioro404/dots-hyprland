import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ContentPage {
    forceWidth: true

    ContentSection {
        icon: "app_registration"
        title: Translation.tr("App")

        Repeater {
            model: Config.options.apps
            ContentSubsection {
                title: Translation.tr(modelData.type.name)

                MaterialTextArea {
                    Layout.fillWidth: true
                    text: modelData.type.provider
                    wrapMode: TextEdit.NoWrap
                    onTextChanged: {
                        modelData.type.provider = text;
                    }
                }
            }
        }
    }
}
