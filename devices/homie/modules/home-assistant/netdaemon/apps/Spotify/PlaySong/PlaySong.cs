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

    public PlaySong(IHaContext ha)
    {
        ha.RegisterServiceCallBack<PlaySongData>(
            "spotify_play_song",
            async (e) =>
            {
                try
                {
                    var result = (await ha.CallServiceWithResponseAsync(
                        "spotifyplus",
                        "search_tracks",
                        data: new SpotifyplusSearchTracksParameters
                        {
                            Criteria = $"{e?.artist} {e?.song}",
                            LimitTotal = 1,
                            EntityId = Global.DEFAULT_ENTITY_ID,
                            // My Defaults
                            Market = "CA",
                            IncludeExternal = "audio",
                        }
                    )).Value.Deserialize<SpotifyplusSearchTracksResponse>(_jsonOptions);

                    string uri = result?.Result?.Items?[0]?.Uri ?? throw new NullReferenceException(
                        $"The song {e?.song}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
                    );

                    ha.CallService(
                        "spotifyplus",
                        "player_media_play_tracks",
                        data: new SpotifyplusPlayerMediaPlayTracksParameters
                        {
                            Uris = uri,
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
