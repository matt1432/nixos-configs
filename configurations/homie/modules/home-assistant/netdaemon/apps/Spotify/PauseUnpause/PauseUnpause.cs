using System;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;


namespace NetDaemonConfig.Apps.Spotify.PauseUnpause
{
    public record PauseUnpauseData(bool pause);

    [NetDaemonApp]
    public class PlaySong
    {
        public PlaySong(IHaContext ha, Services services)
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
                                entityId: SpotifyTypes.DefaultEntityId,
                                deviceId: SpotifyTypes.DefaultDevId);
                        }
                        else
                        {
                            services.Spotifyplus.PlayerMediaResume(
                                entityId: SpotifyTypes.DefaultEntityId,
                                deviceId: SpotifyTypes.DefaultDevId);
                        }
                    }
                    catch (Exception error)
                    {
                        services.Notify.PersistentNotification(
                            message: error.Message,
                            title: "Erreur Spotify");
                    }
                }
            );
        }
    }
}
