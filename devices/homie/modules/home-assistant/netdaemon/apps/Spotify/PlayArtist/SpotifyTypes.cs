namespace Spotify;

using System.Collections.Generic;

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

public record Item
{
    public ExternalUrls? External_urls { get; init; }
    public Followers? Followers { get; init; }
    public List<string?>? Genres { get; init; }
    public string? Href { get; init; }
    public string? Id { get; init; }
    public string? Image_url { get; init; }
    public List<Image>? Images { get; init; }
    public string? Name { get; init; }
    public int Popularity { get; init; }
    public string? Type { get; init; }
    public string? Uri { get; init; }
}

public record Result
{
    public string? Href { get; init; }
    public int Limit { get; init; }
    public string? Next { get; init; }
    public int Offset { get; set; }
    public object? Previous { get; init; }
    public int Total { get; init; }
    public List<Item>? Items { get; init; }
}

public record SpotifyplusSearchArtistsResponse
{
    public UserProfile? UserProfile { get; init; }
    public Result? Result { get; init; }
}

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
