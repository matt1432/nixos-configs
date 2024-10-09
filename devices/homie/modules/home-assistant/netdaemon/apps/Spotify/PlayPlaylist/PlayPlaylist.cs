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

    public PlayPlaylist(IHaContext ha)
    {
        ha.RegisterServiceCallBack<PlayPlaylistData>(
            "spotify_play_playlist",
            async (e) =>
            {
                string? query = e?.playlist;

                var result = (await ha.CallServiceWithResponseAsync(
                    "spotifyplus",
                    "get_playlist_favorites",
                    data: new SpotifyplusGetPlaylistFavoritesParameters
                    {
                        Limit = 50,
                        EntityId = "media_player.spotifyplus",
                        SortResult = true,
                    }
                )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                List<PlaylistsItem>? myPlaylists = result?.Result?.Items;

                if (query is not null && myPlaylists is not null)
                {
                    PlaylistsItem Query = new();
                    Query.Name = query.ToLower();

                    ExtractedResult<PlaylistsItem> match = Process.ExtractOne<PlaylistsItem>(
                        Query,
                        myPlaylists,
                        new Func<PlaylistsItem, string>((item) => (item.Name ?? "").ToLower())
                    );

                    string uri = match.Value!.Uri!;

                    if (match.Score < 85)
                    {
                        var otherResult = (await ha.CallServiceWithResponseAsync(
                            "spotifyplus",
                            "search_playlists",
                            data: new SpotifyplusSearchPlaylistsParameters
                            {
                                Criteria = query,
                                Limit = 1,
                                EntityId = "media_player.spotifyplus",
                            }
                        )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                        uri = otherResult!.Result!.Items![0]!.Uri!;
                    }

                    ha.CallService(
                        "spotifyplus",
                        "player_media_play_context",
                        data: new SpotifyplusPlayerMediaPlayContextParameters
                        {
                            ContextUri = uri,
                            EntityId = "media_player.spotifyplus"
                        }
                    );
                }
            }
        );
    }
}
