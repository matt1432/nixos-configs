namespace Spotify;

using System.Collections.Generic;


public static class Global
{
    public const string DEFAULT_DEV_ID = "homie connect";
    public const string DEFAULT_ENTITY_ID = "media_player.spotifyplus";
}


public record Restrictions { }

public record UserProfile
{
    public string? Country { get; set; }
    public string? DisplayName { get; set; }
    public string? Email { get; set; }
    public string? Id { get; set; }
    public string? Product { get; set; }
    public string? Type { get; set; }
    public string? Uri { get; set; }
}

public record ExternalUrls
{
    public string? Spotify { get; set; }
}

public record Followers
{
    public string? Href { get; set; }
    public int? Total { get; set; }
}

public record Image
{
    public string? Url { get; set; }
    public int? Height { get; set; }
    public int? Width { get; set; }
}

public record Owner
{
    public string? DisplayName { get; set; }
    public ExternalUrls? ExternalUrls { get; set; }
    public Followers? Followers { get; set; }
    public string? Href { get; set; }
    public string? Id { get; set; }
    public string? Type { get; set; }
    public string? Uri { get; set; }
}

public record Tracks
{
    public string? Href { get; set; }
    public int? Total { get; set; }
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

public record ExternalIds
{
    public object? Ean { get; set; }
    public string? Isrc { get; set; }
    public object? Upc { get; set; }
}

public record Album
{
    public string? AlbumType { get; set; }
    public List<Artist>? Artists { get; set; }
    public List<string>? AvailableMarkets { get; set; }
    public List<object>? Copyrights { get; set; }
    public ExternalIds? ExternalIds { get; set; }
    public ExternalUrls? ExternalUrls { get; set; }
    public List<object>? genres { get; set; }
    public string? Href { get; set; }
    public string? Id { get; set; }
    public string? ImageUrl { get; set; }
    public List<Image>? Images { get; set; }
    public object? Label { get; set; }
    public string? Name { get; set; }
    public object? Popularity { get; set; }
    public string? ReleaseDate { get; set; }
    public string? ReleaseDatePrecision { get; set; }
    public Restrictions? Restrictions { get; set; }
    public int? TotalTracks { get; set; }
    public string? Type { get; set; }
    public string? Uri { get; set; }
}
