using System.Collections.Generic;


namespace NetDaemonConfig.Apps.Spotify.Types
{
    public record PlaylistsItem
    {
        public bool? Collaborative { get; set; }
        public string? Description { get; set; }
        public ExternalUrls? ExternalUrls { get; set; }
        public string? Href { get; set; }
        public string? Id { get; set; }
        public string? ImageUrl { get; set; }
        public List<Image>? Images { get; set; }
        public string? Name { get; set; }
        public Owner? Owner { get; set; }
        public bool? Public { get; set; }
        public string? SnapshotId { get; set; }
        public Tracks? Tracks { get; set; }
        public string? Type { get; set; }
        public string? Uri { get; set; }
    }

    public record PlaylistsResult
    {
        public string? Href { get; set; }
        public int? Limit { get; set; }
        public object? Next { get; set; }
        public int? Offset { get; set; }
        public object? Previous { get; set; }
        public int? Total { get; set; }
        public List<PlaylistsItem>? Items { get; set; }
    }

    public record SpotifyplusPlaylistResponse
    {
        public UserProfile? UserProfile { get; set; }
        public PlaylistsResult? Result { get; set; }
    }
}
