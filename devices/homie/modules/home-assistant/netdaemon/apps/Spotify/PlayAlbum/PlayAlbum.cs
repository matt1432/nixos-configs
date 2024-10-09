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

    public PlayAlbum(IHaContext ha)
    {
        ha.RegisterServiceCallBack<PlayAlbumData>(
            "spotify_play_album",
            async (e) =>
            {
                try
                {
                    var result = (await ha.CallServiceWithResponseAsync(
                        "spotifyplus",
                        "search_albums",
                        data: new SpotifyplusSearchAlbumsParameters
                        {
                            Criteria = $"{e?.artist} {e?.album}",
                            LimitTotal = 1,
                            EntityId = Global.DEFAULT_ENTITY_ID,
                            // My Defaults
                            Market = "CA",
                            IncludeExternal = "audio",
                        }
                    )).Value.Deserialize<SpotifyplusSearchAlbumsResponse>(_jsonOptions);

                    string uri = result?.Result?.Items?[0]?.Uri ??
                        throw new NullReferenceException(
                            $"The album {e?.album}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
                        );

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
                catch (Exception error)
                {
                    ha.CallService(
                        "notify",
                        "persistent_notification",
                        data: new PersistentNotificationCreateParameters
                        {
                            Message = error.Message,
                            Title = "Erreur Spotify",
                        }
                    );
                }
            }
        );
    }
}
