pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Greetd
import Astra.Airlock
import "modules"

ShellRoot {
    id: root

    
    FontLoader {
        source: Qt.resolvedUrl("assets/fonts/GoogleSansFlex-VariableFont_GRAD,ROND,opsz,slnt,wdth,wght.ttf")
    }

    
    FontLoader {
        source: Qt.resolvedUrl("assets/fonts/TitanOne-Regular.ttf")
    }

    
    
    FloatingWindow {
        id: greeterWindow
        title: "Airlock"
        fullscreen: true
        visible: true

        GreeterSurface {
            anchors.fill: parent
            onExitRequested: Qt.quit()
        }
    }

    Component.onCompleted: {
        SessionDiscovery.reload();
        UserDiscovery.reload();
    }
}
