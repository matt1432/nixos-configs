namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System.Text.Json;

record ServiceData(string? criteria);

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
        ha.RegisterServiceCallBack<ServiceData>(
            "spotify_play_artist",
            async (e) =>
            {
                var result = (await ha.CallServiceWithResponseAsync(
                    "spotifyplus",
                    "search_artists",
                    data: new SpotifyplusSearchArtistsParameters
                    {
                        Criteria = e?.criteria,
                        Limit = 1,
                        EntityId = "media_player.spotifyplus"
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
                            EntityId = "media_player.spotifyplus"
                        }
                    );
                }
            }
        );
    }
}
