namespace Spotify;

using FuzzySharp;
using FuzzySharp.Extractor;
using HomeAssistantGenerated;
using NetDaemon.AppModel;
using NetDaemon.HassModel;
using NetDaemon.HassModel.Integration;
using System;
using System.Collections.Generic;
using System.Text.Json;

record PlayPlaylistData(string? playlist);


[NetDaemonApp]
public class PlayPlaylist
{
    // Snake-case json options
    private readonly JsonSerializerOptions _jsonOptions = new JsonSerializerOptions
    {
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
    };

    public PlayPlaylist(IHaContext ha, Services services, Entities entities)
    {
        ha.RegisterServiceCallBack<PlayPlaylistData>(
            "spotify_play_playlist",
            async (e) =>
            {
                try
                {
                    string query = e?.playlist ?? throw new NullReferenceException("Query not found.");

                    var result = (await services.Spotifyplus.GetPlaylistFavoritesAsync(
                        limitTotal: 200,
                        sortResult: true,
                        entityId: Global.DEFAULT_ENTITY_ID
                    )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                    List<PlaylistsItem> myPlaylists = result?.Result?.Items ??
                        throw new NullReferenceException($"No playlists found for query {query}");

                    ExtractedResult<PlaylistsItem> match = Process.ExtractOne<PlaylistsItem>(
                        new PlaylistsItem { Name = query.ToLower() },
                        myPlaylists,
                        new Func<PlaylistsItem, string>((item) => (item.Name ?? "").ToLower())
                    );

                    string uri = match.Value?.Uri ??
                        throw new NullReferenceException($"No matches found for query {query}");

                    // We search outside the user's playlists if the score is too low
                    if (match.Score < 85)
                    {
                        var otherResult = (await services.Spotifyplus.SearchPlaylistsAsync(
                            criteria: query,
                            limitTotal: 1,
                            entityId: Global.DEFAULT_ENTITY_ID,
                            // My Defaults
                            market: "CA",
                            includeExternal: "audio"
                        )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                        string potentialUri = otherResult?.Result?.Items?[0]?.Uri ??
                            throw new NullReferenceException($"No public matches found for query {query}");

                        uri = potentialUri;
                    }

                    services.Spotifyplus.PlayerMediaPlayContext(
                        contextUri: uri,
                        entityId: Global.DEFAULT_ENTITY_ID,
                        deviceId: Global.DEFAULT_DEV_ID,
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
