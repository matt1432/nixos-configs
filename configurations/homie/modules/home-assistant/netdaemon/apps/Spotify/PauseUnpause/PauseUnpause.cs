using System;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;

using NetDaemonConfig.Apps.Spotify.Types;


namespace NetDaemonConfig.Apps.Spotify.PauseUnpause
{
    public record PauseUnpauseData(bool pause);

    [NetDaemonApp]
    public class PauseUnpause
    {
        public PauseUnpause(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PauseUnpauseData>(
                "spotify_pause_unpause",
                (e) =>
                {
                    try
                    {
                        if (e.pause)
                        {
                            services.Spotifyplus.PlayerMediaPause(
                                entityId: Globals.DefaultEntityId,
                                deviceId: Globals.DefaultDevId);
                        }
                        else
                        {
                            services.Spotifyplus.PlayerMediaResume(
                                entityId: Globals.DefaultEntityId,
                                deviceId: Globals.DefaultDevId);
                        }
                    }
                    catch (Exception error)
                    {
                        services.Notify.PersistentNotification(
                            message: error.Message + "\n" + e.ToString(),
                            title: "Erreur Spotify");
                    }
                }
            );
        }
    }
}
