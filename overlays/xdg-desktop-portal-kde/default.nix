(final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    xdg-desktop-portal-kde = kprev.xdg-desktop-portal-kde.overrideAttrs (o: {
      patches =
        (o.patches or [])
        ++ [
          # https://invent.kde.org/plasma/xdg-desktop-portal-kde/-/issues/15#note_906047
          (builtins.toFile
            "rdp.patch"
            (
              if o.version == "6.1.3"
              # cpp
              then ''
                diff --git a/src/remotedesktop.cpp b/src/remotedesktop.cpp
                index 99ce57f..af64eff 100644
                --- a/src/remotedesktop.cpp
                +++ b/src/remotedesktop.cpp
                @@ -19,6 +19,8 @@
                 #include <KNotification>
                 #include <QGuiApplication>
                 #include <QRegion>
                +#include <KSharedConfig>
                +#include <KConfigGroup>
                 #include <QScreen>

                 RemoteDesktopPortal::RemoteDesktopPortal(QObject *parent)
                @@ -152,14 +154,19 @@ uint RemoteDesktopPortal::Start(const QDBusObjectPath &handle,
                         notification->setIconName(QStringLiteral("krfb"));
                         notification->sendEvent();
                     } else {
                -        QScopedPointer<RemoteDesktopDialog, QScopedPointerDeleteLater> remoteDesktopDialog(
                -            new RemoteDesktopDialog(app_id, session->deviceTypes(), session->screenSharingEnabled()));
                -        Utils::setParentWindow(remoteDesktopDialog->windowHandle(), parent_window);
                -        Request::makeClosableDialogRequest(handle, remoteDesktopDialog.get());
                -        connect(session, &Session::closed, remoteDesktopDialog.data(), &RemoteDesktopDialog::reject);
                -
                -        if (!remoteDesktopDialog->exec()) {
                -            return 1;
                +        auto cfg = KSharedConfig::openConfig(QStringLiteral("plasmaremotedesktoprc"));
                +        const auto unattendedAccess = cfg->group("Sharing").readEntry("Unattended", false);
                +        if (!unattendedAccess)
                +        {
                +            QScopedPointer<RemoteDesktopDialog, QScopedPointerDeleteLater> remoteDesktopDialog(
                +                new RemoteDesktopDialog(app_id, session->deviceTypes(), session->screenSharingEnabled()));
                +            Utils::setParentWindow(remoteDesktopDialog->windowHandle(), parent_window);
                +            Request::makeClosableDialogRequest(handle, remoteDesktopDialog.get());
                +            connect(session, &Session::closed, remoteDesktopDialog.data(), &RemoteDesktopDialog::reject);
                +
                +            if (!remoteDesktopDialog->exec()) {
                +                return 1;
                +            }
                         }
                     }

              ''
              # cpp
              else ''
                diff --git a/src/remotedesktop.cpp b/src/remotedesktop.cpp
                index 02a32a7..6b9b687 100644
                --- a/src/remotedesktop.cpp
                +++ b/src/remotedesktop.cpp
                @@ -22,6 +22,8 @@
                 #include <QDBusReply>
                 #include <QGuiApplication>
                 #include <QRegion>
                +#include <KSharedConfig>
                +#include <KConfigGroup>
                 #include <QScreen>

                 using namespace Qt::StringLiterals;
                @@ -178,14 +180,19 @@ uint RemoteDesktopPortal::Start(const QDBusObjectPath &handle,
                         notification->setIconName(QStringLiteral("krfb"));
                         notification->sendEvent();
                     } else {
                -        QScopedPointer<RemoteDesktopDialog, QScopedPointerDeleteLater> remoteDesktopDialog(
                -            new RemoteDesktopDialog(app_id, session->deviceTypes(), session->screenSharingEnabled(), session->persistMode()));
                -        Utils::setParentWindow(remoteDesktopDialog->windowHandle(), parent_window);
                -        Request::makeClosableDialogRequest(handle, remoteDesktopDialog.get());
                -        connect(session, &Session::closed, remoteDesktopDialog.data(), &RemoteDesktopDialog::reject);
                -
                -        if (!remoteDesktopDialog->exec()) {
                -            return 1;
                +        auto cfg = KSharedConfig::openConfig(QStringLiteral("plasmaremotedesktoprc"));
                +        const auto unattendedAccess = cfg->group("Sharing").readEntry("Unattended", false);
                +        if (!unattendedAccess)
                +        {
                +            QScopedPointer<RemoteDesktopDialog, QScopedPointerDeleteLater> remoteDesktopDialog(
                +                new RemoteDesktopDialog(app_id, session->deviceTypes(), session->screenSharingEnabled(), session->persistMode()));
                +            Utils::setParentWindow(remoteDesktopDialog->windowHandle(), parent_window);
                +            Request::makeClosableDialogRequest(handle, remoteDesktopDialog.get());
                +            connect(session, &Session::closed, remoteDesktopDialog.data(), &RemoteDesktopDialog::reject);
                +
                +            if (!remoteDesktopDialog->exec()) {
                +                return 1;
                +            }
                         }
                     }
              ''
            ))
        ];
    });
  });
})
