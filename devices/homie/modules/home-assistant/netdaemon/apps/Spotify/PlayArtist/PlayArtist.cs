namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
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

    public PlayArtist(IHaContext ha)
    {
        ha.RegisterServiceCallBack<PlayArtistData>(
            "spotify_play_artist",
            async (e) =>
            {
                var result = (await ha.CallServiceWithResponseAsync(
                    "spotifyplus",
                    "search_artists",
                    data: new SpotifyplusSearchArtistsParameters
                    {
                        Criteria = e?.artist,
                        LimitTotal = 1,
                        EntityId = Global.DEFAULT_ENTITY_ID,
                        // My Defaults
                        Market = "CA",
                        IncludeExternal = "audio",
                    }
                )).Value.Deserialize<SpotifyplusSearchArtistsResponse>(_jsonOptions);

                string? uri = result?.Result?.Items?[0]?.Uri;

                if (uri is not null)
                {
                    ha.CallService(
                        "spotifyplus",
                        "player_media_play_context",
                        data: new SpotifyplusPlayerMediaPlayContextParameters
                        {
                            ContextUri = uri,
                            EntityId = Global.DEFAULT_ENTITY_ID,
                            DeviceId = Global.DEFAULT_DEV_ID,
                            // My Defaults
                            PositionMs = 0,
                            Delay = 0.50,
                        }
                    );
                }
            }
        );
    }
}
