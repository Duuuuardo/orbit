import QtQuick
import Quickshell
import Orbit.Config
import qs.services

Scope {
    Component.onCompleted: {
        

        IdleInhibitor;
        GameMode;
        Notifs;
        Players;
        Brightness;
        Weather.reload();

        if (GlobalConfig.utilities.vpn.enabled)
            VPN;
    }
}
