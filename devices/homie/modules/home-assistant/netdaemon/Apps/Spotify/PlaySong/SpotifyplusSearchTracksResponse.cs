using System.Collections.Generic;


namespace NetDaemonConfig.Apps.Spotify.PlaySong
{
    public record SongItem
    {
        public Album? Album { get; set; }
        public List<Artist>? Artists { get; set; }
        public List<string>? AvailableMarkets { get; set; }
        public int? DiscNumber { get; set; }
        public int? DurationMs { get; set; }
        public bool? Explicit { get; set; }
        public ExternalIds? ExternalIds { get; set; }
        public ExternalUrls? ExternalUrls { get; set; }
        public string? Href { get; set; }
        public string? Id { get; set; }
        public string? ImageUrl { get; set; }
        public bool? IsLocal { get; set; }
        public object? IsPlayable { get; set; }
        public string? Name { get; set; }
        public int? Popularity { get; set; }
        public object? PreviewUrl { get; set; }
        public Restrictions? Restrictions { get; set; }
        public int? TrackNumber { get; set; }
        public string? Type { get; set; }
        public string? Uri { get; set; }
    }

    public record SongResult
    {
        public string? Href { get; set; }
        public int? Limit { get; set; }
        public string? Next { get; set; }
        public int? Offset { get; set; }
        public object? Previous { get; set; }
        public int? Total { get; set; }
        public List<SongItem>? Items { get; set; }
    }

    public record SpotifyplusSearchTracksResponse
    {
        public UserProfile? UserProfile { get; set; }
        public SongResult? Result { get; set; }
    }
}
