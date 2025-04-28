pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    property string time: Qt.formatDateTime(clock.date, "ddd. d MMM. h:mm AP")
    property string uptime: "0h, 0m"

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    Timer {
        interval: 10
        repeat: true
        running: true

        onTriggered: {
            fileUptime.reload();
            const textUptime = fileUptime.text();
            const uptimeSeconds = Number(textUptime.split(" ")[0] ?? 0);

            // Convert seconds to days, hours, and minutes
            const days = Math.floor(uptimeSeconds / 86400);
            const hours = Math.floor((uptimeSeconds % 86400) / 3600);
            const minutes = Math.floor((uptimeSeconds % 3600) / 60);

            // Build the formatted uptime string
            let formatted = "";
            if (days > 0)
                formatted += `${days}d`;
            if (hours > 0)
                formatted += `${formatted ? ", " : ""}${hours}h`;
            if (minutes > 0 || !formatted)
                formatted += `${formatted ? ", " : ""}${minutes}m`;
            DateTime.uptime = formatted;
        }
    }

    FileView {
        id: fileUptime

        path: "/proc/uptime"
    }
}
