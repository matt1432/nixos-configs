using System.Collections.Generic;


namespace NetDaemonConfig.Apps.Spotify.PlayAlbum
{
    public record AlbumItem
    {
        public string? AlbumType { get; set; }
        public List<Artist>? Artists { get; set; }
        public List<string>? AvailableMarkets { get; set; }
        public ExternalUrls? ExternalUrls { get; set; }
        public string? Href { get; set; }
        public string? Id { get; set; }
        public string? ImageUrl { get; set; }
        public List<Image>? Images { get; set; }
        public string? Name { get; set; }
        public string? ReleaseDate { get; set; }
        public string? ReleaseDatePrecision { get; set; }
        public Restrictions? Restrictions { get; set; }
        public int? TotalTracks { get; set; }
        public string? Type { get; set; }
        public string? Uri { get; set; }
    }

    public record AlbumResult
    {
        public string? Href { get; set; }
        public int? Limit { get; set; }
        public string? Next { get; set; }
        public int? Offset { get; set; }
        public object? Previous { get; set; }
        public int? Total { get; set; }
        public List<AlbumItem>? Items { get; set; }
    }

    public record SpotifyplusSearchAlbumsResponse
    {
        public UserProfile? UserProfile { get; set; }
        public AlbumResult? Result { get; set; }
    }
}
