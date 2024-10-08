namespace Spotify;

public record UserProfile
{
    public string? Country { get; init; }
    public string? DisplayName { get; init; }
    public string? Email { get; init; }
    public string? Id { get; init; }
    public string? Product { get; init; }
    public string? Type { get; init; }
    public string? Uri { get; init; }
}

public record Artist
{
    public ExternalUrls? ExternalUrls { get; set; }
    public string? Href { get; set; }
    public string? Id { get; set; }
    public string? Name { get; set; }
    public string? Type { get; set; }
    public string? Uri { get; set; }
}

public record ExternalUrls
{
    public string? Spotify { get; init; }
}

public record Followers
{
    public string? Href { get; init; }
    public int Total { get; init; }
}

public record Image
{
    public string? Url { get; init; }
    public int Height { get; init; }
    public int Width { get; init; }
}

public record Restrictions { }
