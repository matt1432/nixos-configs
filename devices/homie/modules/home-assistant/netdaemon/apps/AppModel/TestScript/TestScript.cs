namespace AppModel;

using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System.Text.Json;

record ServiceData(string? criteria);

[NetDaemonApp]
public class TestScript
{
    // Snake-case json options
    private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
    };

    public TestScript(IHaContext ha)
    {
        ha.RegisterServiceCallBack<ServiceData>(
            "callback_demo",
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
                        "notify",
                        "persistent_notification",
                        data: new PersistentNotificationCreateParameters
                        {
                            Message = $"value: {uri}",
                            Title = "title"
                        }
                    );
                }
            }
        );
    }
}
