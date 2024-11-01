using System;
using System.Reflection;
using System.Text.Json;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;


namespace NetDaemonConfig.Apps.Spotify.PlayAlbum
{
    public record PlayAlbumData(string? Artist, string? Album);

    [NetDaemonApp]
    public class PlayAlbum
    {
        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        public PlayAlbum(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayAlbumData>(
                "spotify_play_album",
                async (e) =>
                {
                    try
                    {
                        SpotifyplusSearchAlbumsResponse? result = (
                            await services.Spotifyplus.SearchAlbumsAsync(
                                criteria: $"{e?.Artist} {e?.Album}",
                                limitTotal: 1,
                                entityId: SpotifyTypes.DefaultEntityId,
                                // My Defaults
                                market: "CA",
                                includeExternal: "audio"
                            )
                        ).Value.Deserialize<SpotifyplusSearchAlbumsResponse>(_jsonOptions);

                        string uri = result?.Result?.Items?[0]?.Uri ??
                            throw new TargetException(
                                $"The album {e?.Album}{(e?.Artist is null ? "" : $" by {e?.Artist}")} could not be found."
                            );

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
