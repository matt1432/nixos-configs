namespace AppModel;

/// <summary>
///     Showcases how to instance apps with yaml and use automatic configuration population
/// </summary>
[NetDaemonApp]
public class HelloYamlApp
{
    public HelloYamlApp(IHaContext ha, IAppConfig<HelloConfig> config)
    {
        ha.CallService("notify", "persistent_notification",
            data: new {message = config.Value.HelloMessage, title = "Hello yaml app!"});
    }
}

public class HelloConfig
{
    public string? HelloMessage { get; set; }
}