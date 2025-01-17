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

using NetDaemonConfig.Apps.Spotify.Types;


namespace NetDaemonConfig.Apps.Spotify.PlayAlbum
{
    public record PlayAlbumData(string? artist, string? album);

    [NetDaemonApp]
    public class PlayAlbum
    {
        private readonly CultureInfo _cultureInfo = new("fr-CA", false);

        // Snake-case json options
        private readonly JsonSerializerOptions _jsonOptions = new()
        {
            PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower
        };

        public PlayAlbum(IHaContext ha, Services services)
        {
            ha.RegisterServiceCallBack<PlayAlbumData>(
                "spotify_play_album",
                async (e) =>
                {
                    try
                    {
                        string uri;

                        if (e.artist is not null)
                        {
                            SpotifyplusSearchArtistsResponse? artistResult = (
                                await services.Spotifyplus.SearchArtistsAsync(
                                    criteria: e?.artist ??
                                        throw new TargetException($"The artist {e?.artist} could not be found."),
                                    limitTotal: 1,
                                    entityId: Globals.DefaultEntityId,
                                    // My Defaults
                                    market: "CA",
                                    includeExternal: "audio"
                                )
                            ).Value.Deserialize<SpotifyplusSearchArtistsResponse>(_jsonOptions);

                            string artistId = artistResult?.Result?.Items?[0]?.Id ??
                                throw new TargetException($"The artist {e?.artist} could not be found.");

                            SpotifyPlusGetArtistAlbumsResponse? result = (
                                await services.Spotifyplus.GetArtistAlbumsAsync(
                                    artistId: artistId,
                                    entityId: Globals.DefaultEntityId,
                                    market: "CA"
                                )
                            ).Value.Deserialize<SpotifyPlusGetArtistAlbumsResponse>(_jsonOptions);

                            List<ArtistAlbumItem> albums = result?.Result?.Items ??
                                throw new TargetException($"No albums found for artist {e.artist}");

                            ExtractedResult<ArtistAlbumItem> match = Process.ExtractOne(
                                new ArtistAlbumItem { Name = e.album?.ToLower(_cultureInfo) },
                                albums,
                                new Func<ArtistAlbumItem, string>((item) =>
                                    (item.Name ?? "").ToLower(_cultureInfo))
                            );

                            uri = match.Value?.Uri ??
                                throw new TargetException($"No matches found for album {e.album}");
                        }
                        else
                        {
                            SpotifyplusSearchAlbumsResponse? result = (
                                await services.Spotifyplus.SearchAlbumsAsync(
                                    criteria: $"{e?.album}",
                                    limitTotal: 1,
                                    entityId: Globals.DefaultEntityId,
                                    // My Defaults
                                    market: "CA",
                                    includeExternal: "audio"
                                )
                            ).Value.Deserialize<SpotifyplusSearchAlbumsResponse>(_jsonOptions);

                            uri = result?.Result?.Items?[0]?.Uri ??
                                throw new TargetException(
                                    $"The album {e?.album}{(e?.artist is null ? "" : $" by {e?.artist}")} could not be found."
                                );
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
                    catch (Exception error)
                    {
                        services.Notify.PersistentNotification(
                            message: error.Message + "\n" + e.ToString(),
                            title: "Erreur Spotify");
                    }
                }
            );
        }
    }
}
