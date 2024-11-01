using System;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using System.Text.Json;

using FuzzySharp;
using FuzzySharp.Extractor;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;


namespace NetDaemonConfig.Apps.Spotify.PlayPlaylist
{
    public record PlayPlaylistData(string? Playlist);

    [NetDaemonApp]
    public class PlayPlaylist
    {
        private readonly CultureInfo _cultureInfo = new("fr-CA", false);

        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        public PlayPlaylist(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayPlaylistData>(
                "spotify_play_playlist",
                async (e) =>
                {
                    try
                    {
                        string query = e?.Playlist ?? throw new TargetException("Query not found.");

                        SpotifyplusPlaylistResponse? result = (
                            await services.Spotifyplus.GetPlaylistFavoritesAsync(
                                limitTotal: 200,
                                sortResult: true,
                                entityId: SpotifyTypes.DefaultEntityId
                            )
                        ).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                        List<PlaylistsItem> myPlaylists = result?.Result?.Items ??
                            throw new TargetException($"No playlists found for query {query}");

                        ExtractedResult<PlaylistsItem> match = Process.ExtractOne(
                            new PlaylistsItem { Name = query.ToLower(_cultureInfo) },
                            myPlaylists,
                            new Func<PlaylistsItem, string>((item) => (item.Name ?? "").ToLower(_cultureInfo))
                        );

                        string uri = match.Value?.Uri ?? throw new TargetException($"No matches found for query {query}");

                        // We search outside the user's playlists if the score is too low
                        if (match.Score < 85)
                        {
                            SpotifyplusPlaylistResponse? otherResult = (
                                await services.Spotifyplus.SearchPlaylistsAsync(
                                    criteria: query,
                                    limitTotal: 1,
                                    entityId: SpotifyTypes.DefaultEntityId,
                                    // My Defaults
                                    market: "CA",
                                    includeExternal: "audio"
                                )
                            ).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                            string potentialUri = otherResult?.Result?.Items?[0]?.Uri ??
                                throw new TargetException($"No public matches found for query {query}");

                            uri = potentialUri;
                        }

                        services.Spotifyplus.PlayerMediaPlayContext(
                            contextUri: uri,
                            entityId: SpotifyTypes.DefaultEntityId,
                            deviceId: SpotifyTypes.DefaultDevId,
                            // My Defaults
                            positionMs: 0,
                            delay: 0.50
                        );
                    }
                    catch (Exception error)
                    {
                        services.PersistentNotification.Create(
                            message: error.Message,
                            title: "Erreur Spotify");
                    }
                }
            );
        }
    }
}
