namespace AppModel;

record ServiceData(string? action, int value);

/// <summary>
///     Showcases how to instance apps with yaml and use automatic configuration population
/// </summary>
[NetDaemonApp]
public class TestScript
{
    public TestScript(IHaContext ha)
    {
        ha.RegisterServiceCallBack<ServiceData>(
            "callback_demo",
            e => ha.CallService(
                "notify",
                "persistent_notification",
                data: new {message = $"value: {e?.value}", title = $"{e?.action}"}
            )
        );
    }
}
