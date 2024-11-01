using System;
using System.Reflection;
using System.Text.Json;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;


namespace NetDaemonConfig.Apps.Spotify.PlayArtist
{
    public record PlayArtistData(string? Artist);

    [NetDaemonApp]
    public class PlayArtist
    {
        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        public PlayArtist(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayArtistData>(
                "spotify_play_artist",
                async (e) =>
                {
                    try
                    {
                        SpotifyplusSearchArtistsResponse? result = (
                            await services.Spotifyplus.SearchArtistsAsync(
                                criteria: e?.Artist ?? throw new TargetException($"The artist {e?.Artist} could not be found."),
                                limitTotal: 1,
                                entityId: SpotifyTypes.DefaultEntityId,
                                // My Defaults
                                market: "CA",
                                includeExternal: "audio"
                            )
                        ).Value.Deserialize<SpotifyplusSearchArtistsResponse>(_jsonOptions);

                        string uri = result?.Result?.Items?[0]?.Uri ??
                            throw new TargetException($"The artist {e?.Artist} could not be found.");

                        services.Spotifyplus.PlayerMediaPlayContext(
                            contextUri: uri,
                            entityId: SpotifyTypes.DefaultEntityId,
                            deviceId: SpotifyTypes.DefaultDevId,
                            // My Defaults
                            positionMs: 0,
                            delay: 0.50
                        );
                    }
                    catch (Exception error)
                    {
                        services.PersistentNotification.Create(
                            message: error.Message,
                            title: "Erreur Spotify");
                    }
                }
            );
        }
    }
}
