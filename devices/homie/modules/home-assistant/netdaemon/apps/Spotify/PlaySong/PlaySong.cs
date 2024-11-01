namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System;
using System.Text.Json;

record PlaySongData(string? artist, string? song);

[NetDaemonApp]
public class PlaySong
{
    // Snake-case json options
    private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
    };

    public PlaySong(IHaContext ha, Services services, Entities entities)
    {
        ha.RegisterServiceCallBack<PlaySongData>(
            "spotify_play_song",
            async (e) =>
            {
                try
                {
                    var result = (await services.Spotifyplus.SearchTracksAsync(
                        criteria: $"{e?.artist} {e?.song}",
                        limitTotal: 1,
                        entityId: Global.DEFAULT_ENTITY_ID,
                        // My Defaults
                        market: "CA",
                        includeExternal: "audio"
                    )).Value.Deserialize<SpotifyplusSearchTracksResponse>(_jsonOptions);

                    string uri = result?.Result?.Items?[0]?.Uri ?? throw new NullReferenceException(
                        $"The song {e?.song}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
                    );

                    services.Spotifyplus.PlayerMediaPlayTracks(
                        uris: uri,
                        entityId: Global.DEFAULT_ENTITY_ID,
                        deviceId: Global.DEFAULT_DEV_ID,
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
