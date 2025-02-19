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
        private static void CallBack(PauseUnpauseData e, Services services)
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

        public PauseUnpause(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PauseUnpauseData>(
                "spotify_pause_unpause",
                (e) => Globals.RunSpotifyCallback(services, e, CallBack)
            );
        }
    }
}
