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
                        LimitTotal = 200,
                        SortResult = true,
                        EntityId = Global.DEFAULT_ENTITY_ID,
                    }
                )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                List<PlaylistsItem>? myPlaylists = result?.Result?.Items;

                if (query is not null && myPlaylists is not null)
                {
                    ExtractedResult<PlaylistsItem> match = Process.ExtractOne<PlaylistsItem>(
                        new PlaylistsItem { Name = query.ToLower() },
                        myPlaylists,
                        new Func<PlaylistsItem, string>((item) => (item.Name ?? "").ToLower())
                    );

                    string uri = match.Value!.Uri!;

                    // We search outside the user's playlists if the score is too low
                    if (match.Score < 85)
                    {
                        var otherResult = (await ha.CallServiceWithResponseAsync(
                            "spotifyplus",
                            "search_playlists",
                            data: new SpotifyplusSearchPlaylistsParameters
                            {
                                Criteria = query,
                                LimitTotal = 1,
                                EntityId = Global.DEFAULT_ENTITY_ID,
                                // My Defaults
                                Market = "CA",
                                IncludeExternal = "audio",
                            }
                        )).Value.Deserialize<SpotifyplusPlaylistResponse>(_jsonOptions);

                        string? potentialUri = otherResult?.Result?.Items?[0]?.Uri;

                        if (potentialUri is not null)
                        {
                            uri = potentialUri;
                        }
                    }

                    ha.CallService(
                        "spotifyplus",
                        "player_media_play_context",
                        data: new SpotifyplusPlayerMediaPlayContextParameters
                        {
                            ContextUri = uri,
                            EntityId = Global.DEFAULT_ENTITY_ID,
                            DeviceId = Global.DEFAULT_DEV_ID,
                            // My Defaults
                            PositionMs = 0,
                            Delay = 0.50,
                        }
                    );
                }
            }
        );
    }
}
