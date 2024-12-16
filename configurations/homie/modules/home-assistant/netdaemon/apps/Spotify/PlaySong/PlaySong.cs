using System;
using System.Text.Json;
using System.Reflection;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;


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

        public PlaySong(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlaySongData>(
                "spotify_play_song",
                async (e) =>
                {
                    try
                    {
                        SpotifyplusSearchTracksResponse? result = (
                            await services.Spotifyplus.SearchTracksAsync(
                                criteria: $"{e?.artist} {e?.song}",
                                limitTotal: 1,
                                entityId: SpotifyTypes.DefaultEntityId,
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
                            entityId: SpotifyTypes.DefaultEntityId,
                            deviceId: SpotifyTypes.DefaultDevId,
                            // My Defaults
                            positionMs: 0,
                            delay: 0.50
                        );
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
