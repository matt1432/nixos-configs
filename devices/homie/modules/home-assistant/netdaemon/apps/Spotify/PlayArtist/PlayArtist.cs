namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System;
using System.Text.Json;

record PlayArtistData(string? artist);


[NetDaemonApp]
public class PlayArtist
{
    // Snake-case json options
    private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
    };

    public PlayArtist(IHaContext ha, Services services, Entities entities)
    {
        ha.RegisterServiceCallBack<PlayArtistData>(
            "spotify_play_artist",
            async (e) =>
            {
                try
                {
                    var result = (await services.Spotifyplus.SearchArtistsAsync(
                        criteria: e?.artist ?? throw new NullReferenceException($"The artist {e?.artist} could not be found."),
                        limitTotal: 1,
                        entityId: Global.DEFAULT_ENTITY_ID,
                        // My Defaults
                        market: "CA",
                        includeExternal: "audio"
                    )).Value.Deserialize<SpotifyplusSearchArtistsResponse>(_jsonOptions);

                    string uri = result?.Result?.Items?[0]?.Uri ??
                        throw new NullReferenceException($"The artist {e?.artist} could not be found.");

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
