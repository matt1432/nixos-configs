(final: prev: {
  kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
    xdg-desktop-portal-kde = kprev.xdg-desktop-portal-kde.overrideAttrs (o: {
      patches =
        (o.patches or [])
        ++ [
          # https://invent.kde.org/plasma/xdg-desktop-portal-kde/-/issues/15#note_906047
          (builtins.toFile
            "rdp.patch"
            # cpp
            ''
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

            '')
        ];
    });
  });
})
