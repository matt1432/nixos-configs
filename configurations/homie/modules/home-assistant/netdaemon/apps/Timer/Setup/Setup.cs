using System;
using System.Linq;
using System.Reactive.Linq;
using System.Text.Json;
using System.Text.Json.Serialization;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Entities;


namespace NetDaemonConfig.Apps.Timer.Setup
{
    public record TimerFinishedEventData
    {
        [JsonPropertyName("entity_id")]
        public string? entity_id { get; init; }
    }

    [NetDaemonApp]
    public class Setup
    {
        private readonly string _timerTarget = "media_player.music_player_daemon";

        private readonly string _timerTtsTarget = "tts.piper";
        private readonly string _timerTtsMessage = "A set timer has finished.";

        // TODO: private readonly string timerMediaLocation = "/path/to/file.mp3";

        public Setup(IHaContext ha, Services services, Entities entities)
        {
            ha.Events
                .Where(x => x.EventType == "timer.finished")
                .Subscribe(x =>
                {
                    if (x.DataElement.HasValue)
                    {
                        var data = JsonSerializer.Deserialize<TimerFinishedEventData>(x.DataElement.Value);

                        if (data?.entity_id?.StartsWith("timer.assist_timer") ?? false)
                        {
                            var timer = entities.Timer
                                .EnumerateAll()
                                .ToLookup((timer) => timer.EntityId,
                                        (timer) => timer)[data.entity_id].First();

                            if (timer is not null)
                            {
                                services.Tts.Speak(
                                    cache: true,
                                    mediaPlayerEntityId: _timerTarget,
                                    target: new ServiceTarget { EntityIds = [_timerTtsTarget] },
                                    message: _timerTtsMessage);
                            }
                        }
                    }
                });

            /*
            entities.Timer.EnumerateAll()
                .Where((timer) => timer.EntityId.StartsWith("timer.assist_timer"))
                .StateChanges()
                .Subscribe((timer) =>
                {
                    if (timer.Old?.State != "idle" && timer.New?.State == "idle")
                    {}
                });
            */
        }
    }
}
