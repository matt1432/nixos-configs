using System.Reflection;
using System.Text.Json;
using System.Threading.Tasks;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;

using NetDaemonConfig.Apps.Spotify.Types;


namespace NetDaemonConfig.Apps.Spotify.PlaySong
{
    public record PlaySongData(string? artist, string? song);

    [NetDaemonApp]
    public class PlaySong
    {
        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        private async Task CallBack(PlaySongData e, Services services)
        {
            SpotifyplusSearchTracksResponse? result = (
                await services.Spotifyplus.SearchTracksAsync(
                    criteria: $"{e?.artist} {e?.song}",
                    limitTotal: 1,
                    entityId: Globals.DefaultEntityId,
                    // My Defaults
                    market: "CA",
                    includeExternal: "audio"
                )
            ).Value.Deserialize<SpotifyplusSearchTracksResponse>(_jsonOptions);

            string uri = result?.Result?.Items?[0]?.Uri ?? throw new TargetException(
                $"The song {e?.song}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
            );

            services.Spotifyplus.PlayerMediaPlayTracks(
                uris: uri,
                entityId: Globals.DefaultEntityId,
                deviceId: Globals.DefaultDevId,
                // My Defaults
                positionMs: 0,
                delay: 0.50
            );
        }

        public PlaySong(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlaySongData>(
                "spotify_play_song",
                (e) => Globals.RunAsyncSpotifyCallback(services, e, CallBack)
            );
        }
    }
}
