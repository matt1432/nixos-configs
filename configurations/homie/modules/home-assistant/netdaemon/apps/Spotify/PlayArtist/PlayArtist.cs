using System.Reflection;
using System.Text.Json;
using System.Threading.Tasks;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;

using NetDaemonConfig.Apps.Spotify.Types;


namespace NetDaemonConfig.Apps.Spotify.PlayArtist
{
    public record PlayArtistData(string? artist);

    [NetDaemonApp]
    public class PlayArtist
    {
        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        private async Task CallBack(PlayArtistData e, Services services)
        {
            SpotifyplusSearchArtistsResponse? result = (
                await services.Spotifyplus.SearchArtistsAsync(
                    criteria: e?.artist ?? throw new TargetException($"The artist {e?.artist} could not be found."),
                    limitTotal: 1,
                    entityId: Globals.DefaultEntityId,
                    // My Defaults
                    market: "CA",
                    includeExternal: "audio"
                )
            ).Value.Deserialize<SpotifyplusSearchArtistsResponse>(_jsonOptions);

            string uri = result?.Result?.Items?[0]?.Uri ??
                throw new TargetException($"The artist {e?.artist} could not be found.");

            services.Spotifyplus.PlayerMediaPlayContext(
                contextUri: uri,
                entityId: Globals.DefaultEntityId,
                deviceId: Globals.DefaultDevId,
                // My Defaults
                positionMs: 0,
                delay: 0.50
            );
        }

        public PlayArtist(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayArtistData>(
                "spotify_play_artist",
                (e) => Globals.RunAsyncSpotifyCallback(services, e, CallBack)
            );
        }
    }
}
