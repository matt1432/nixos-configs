namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System;
using System.Text.Json;

record PlayAlbumData(string? artist, string? album);


[NetDaemonApp]
public class PlayAlbum
{
    // Snake-case json options
    private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
    };

    public PlayAlbum(IHaContext ha, Services services, Entities entities)
    {
        ha.RegisterServiceCallBack<PlayAlbumData>(
            "spotify_play_album",
            async (e) =>
            {
                try
                {
                    var result = (await services.Spotifyplus.SearchAlbumsAsync(
                        criteria: $"{e?.artist} {e?.album}",
                        limitTotal: 1,
                        entityId: Global.DEFAULT_ENTITY_ID,
                        // My Defaults
                        market: "CA",
                        includeExternal: "audio"
                    )).Value.Deserialize<SpotifyplusSearchAlbumsResponse>(_jsonOptions);

                    string uri = result?.Result?.Items?[0]?.Uri ??
                        throw new NullReferenceException(
                            $"The album {e?.album}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
                        );

                    services.Spotifyplus.PlayerMediaPlayContext(
                        contextUri: uri,
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
