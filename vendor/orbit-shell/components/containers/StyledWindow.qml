import Quickshell
import Quickshell.Wayland
import Orbit.Config


PanelWindow {
    
    required property string name

    WlrLayershell.namespace: `orbit-${name}`
    color: "transparent"

    contentItem.Config.screen: screen.name
    contentItem.Tokens.screen: screen.name
}
