using System;
using System.Collections.Generic;
using System.Globalization;
using System.Reflection;
using System.Text.Json;
using System.Threading.Tasks;

using FuzzySharp;
using FuzzySharp.Extractor;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;

using NetDaemonConfig.Apps.Spotify.Types;


namespace NetDaemonConfig.Apps.Spotify.PlayPlaylist
{
    public record PlayPlaylistData(string? playlist);

    [NetDaemonApp]
    public class PlayPlaylist
    {
        private readonly CultureInfo _cultureInfo = new("fr-CA", false);

        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        private async Task CallBack(PlayPlaylistData e, Services services)
        {
            string query = e?.playlist ?? throw new TargetException("Query not found.");

            SpotifyplusPlaylistResponse? result = (
                await services.Spotifyplus.GetPlaylistFavoritesAsync(
                    limitTotal: 200,
                    sortResult: true,
                    entityId: Globals.DefaultEntityId
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
                        entityId: Globals.DefaultEntityId,
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
                entityId: Globals.DefaultEntityId,
                deviceId: Globals.DefaultDevId,
                // My Defaults
                positionMs: 0,
                delay: 0.50
            );
        }

        public PlayPlaylist(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayPlaylistData>(
                "spotify_play_playlist",
                (e) => Globals.RunAsyncSpotifyCallback(services, e, CallBack)
            );
        }
    }
}
