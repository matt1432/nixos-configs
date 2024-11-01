using System.Collections.Generic;

namespace NetDaemonConfig.Apps.Spotify
{
    public static class SpotifyTypes
    {
        public const string DefaultDevId = "homie connect";
        public const string DefaultEntityId = "media_player.spotifyplus";
    }

    // https://jsonformatter.org/yaml-to-json
    // https://json2csharp.com
    // https://github.com/thlucas1/homeassistantcomponent_spotifyplus/blob/master/custom_components/spotifyplus/services.yaml
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
        public List<object>? Genres { get; set; }
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
}
