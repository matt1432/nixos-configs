namespace Spotify;

using System.Collections.Generic;


public record ArtistItem
{
    public ExternalUrls? External_urls { get; init; }
    public Followers? Followers { get; init; }
    public List<string>? Genres { get; init; }
    public string? Href { get; init; }
    public string? Id { get; init; }
    public string? Image_url { get; init; }
    public List<Image>? Images { get; init; }
    public string? Name { get; init; }
    public int? Popularity { get; init; }
    public string? Type { get; init; }
    public string? Uri { get; init; }
}

public record ArtistResult
{
    public string? Href { get; init; }
    public int? Limit { get; init; }
    public string? Next { get; init; }
    public int? Offset { get; set; }
    public object? Previous { get; init; }
    public int? Total { get; init; }
    public List<ArtistItem>? Items { get; init; }
}

public record SpotifyplusSearchArtistsResponse
{
    public UserProfile? UserProfile { get; init; }
    public ArtistResult? Result { get; init; }
}
