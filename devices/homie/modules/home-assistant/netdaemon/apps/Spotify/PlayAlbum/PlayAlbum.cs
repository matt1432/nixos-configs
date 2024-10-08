namespace Spotify;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
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

    public PlayAlbum(IHaContext ha)
    {
        ha.RegisterServiceCallBack<PlayAlbumData>(
            "spotify_play_album",
            async (e) =>
            {
                var result = (await ha.CallServiceWithResponseAsync(
                    "spotifyplus",
                    "search_albums",
                    data: new SpotifyplusSearchAlbumsParameters
                    {
                        Criteria = $"{e?.artist} {e?.album}",
                        Limit = 1,
                        EntityId = "media_player.spotifyplus"
                    }
                )).Value.Deserialize<SpotifyplusSearchAlbumsResponse>(_jsonOptions);

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
