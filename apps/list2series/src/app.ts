import axios from 'axios';
import { spawnSync } from 'child_process';
import FormData from 'form-data';
import {
    createReadStream,
    linkSync,
    mkdirSync,
    readFileSync,
    rmSync,
    writeFileSync,
} from 'fs';
import { basename } from 'path';

import type {
    Book,
    BookMetadata,
    BookPoster,
    ListsJson,
    ReadList,
    ReadlistPoster,
    Series,
    SeriesMetadata,
    SeriesPoster,
} from './types';

// Examples of calling this script:
// $ just l2s copy 0K65Q482KK7SD
// $ just l2s meta 0K65Q482KK7SD

// -----------------
// Helper Functions
// -----------------

const readNeighborFile = (filename: string) =>
    JSON.parse(
        readFileSync(`${process.env.FLAKE}/apps/list2series/${filename}`, {
            encoding: 'utf-8',
        }),
    );

const writeToNeighborFile = (filename: string, content: string) => {
    writeFileSync(`${process.env.FLAKE}/apps/list2series/${filename}`, content);
};

const API = readNeighborFile('.env').API;

const getListInfo = async (listId: string): Promise<ReadList> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/readlists/${listId}`,
        headers: {
            Accept: 'application/json',
            'X-API-Key': API,
        },
    });

    return res.data;
};

const getSeries = async (
    seriesTitle: string,
    operator = true,
): Promise<Series[]> => {
    return (
        await axios.request({
            method: 'post',
            maxBodyLength: Infinity,
            url: 'https://komga.nelim.org/api/v1/series/list?unpaged=true',
            headers: {
                'Content-Type': 'application/json',
                Accept: 'application/json',
                'X-API-Key': API,
            },
            data: JSON.stringify({
                condition: {
                    title: {
                        operator: operator ? 'is' : 'isNot',
                        value: seriesTitle,
                    },
                },
            }),
        })
    ).data.content;
};

const getSeriesBooks = async (
    listName: string,
    seriesPath: string,
): Promise<Book[]> => {
    const thisSeries = (await getSeries('', false)).find(
        (s) => s.url === seriesPath,
    );

    if (!thisSeries) {
        throw new Error('Series could not be found');
    }

    // Reset Series metadata
    axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/series/${thisSeries.id}/metadata`,
        headers: {
            'Content-Type': 'application/json',
            'X-API-Key': API,
        },
        data: JSON.stringify({
            ageRating: null,
            ageRatingLock: true,
            alternateTitles: null,
            alternateTitlesLock: true,
            genres: null,
            genresLock: true,
            language: null,
            languageLock: true,
            links: null,
            linksLock: true,
            publisherLock: true,
            readingDirection: 'LEFT_TO_RIGHT',
            readingDirectionLock: true,
            sharingLabels: null,
            sharingLabelsLock: true,
            status: null,
            statusLock: true,
            summary: null,
            summaryLock: true,
            tags: null,
            tagsLock: true,
            title: listName,
            titleLock: true,
            titleSort: listName,
            titleSortLock: true,
            totalBookCountLock: true,
        }),
    });

    const books = await axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: 'https://komga.nelim.org/api/v1/books/list?unpaged=true',
        headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-API-Key': API,
        },
        data: JSON.stringify({
            condition: {
                seriesId: {
                    operator: 'is',
                    value: thisSeries.id,
                },
            },
        }),
    });

    return books.data.content;
};

const getBookInfo = async (id: string): Promise<Book> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${id}`,
        headers: {
            Accept: 'application/json',
            'X-API-Key': API,
        },
    });

    return res.data;
};

// There doesn't seem to be a way to wait for the scan to be done
const scanLibrary = (): void => {
    axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: 'https://komga.nelim.org/api/v1/libraries/0K4QG58XA29DZ/scan',
        headers: {
            'X-API-Key': API,
        },
    });
};

type BookCoverInfo = BookPoster & { imagePath: string };

const getBookCover = async (book: Book): Promise<BookCoverInfo> => {
    const imagePath = `/tmp/cover${book.id}.jpeg`;

    spawnSync('curl', [
        '-L',
        `https://komga.nelim.org/api/v1/books/${book.id}/thumbnail`,
        '-H',
        `X-API-Key: ${API}`,
        '--output',
        imagePath,
    ]);

    const posterList: BookPoster[] = (
        await axios.request({
            method: 'get',
            maxBodyLength: Infinity,
            url: `https://komga.nelim.org/api/v1/books/${book.id}/thumbnails`,
            headers: {
                Accept: 'application/json',
                'X-API-Key': API,
            },
        })
    ).data;

    const posterInfo = posterList.find((poster) => poster.selected);

    if (!posterInfo) {
        throw new Error(`Poster info for book ${book.id} could not be found`);
    }

    return {
        ...posterInfo,
        imagePath,
    };
};

type ReadlistCoverInfo = ReadlistPoster & { imagePath: string };

const getReadlistCover = async (id: string): Promise<ReadlistCoverInfo> => {
    const imagePath = `/tmp/cover${id}.jpeg`;

    spawnSync('curl', [
        '-L',
        `https://komga.nelim.org/api/v1/readlists/${id}/thumbnail`,
        '-H',
        `X-API-Key: ${API}`,
        '--output',
        imagePath,
    ]);

    const posterList: ReadlistPoster[] = (
        await axios.request({
            method: 'get',
            maxBodyLength: Infinity,
            url: `https://komga.nelim.org/api/v1/readlists/${id}/thumbnails`,
            headers: {
                Accept: 'application/json',
                'X-API-Key': API,
            },
        })
    ).data;

    const posterInfo = posterList.find((poster) => poster.selected);

    if (!posterInfo) {
        throw new Error(`Poster info for readlist ${id} could not be found`);
    }

    return {
        ...posterInfo,
        imagePath,
    };
};

const updateBookCover = async (
    book: Book,
    cover: BookCoverInfo,
): Promise<void> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${book.id}/thumbnails`,
        headers: {
            Accept: 'application/json',
            'X-API-Key': API,
        },
    });

    const posterList: BookPoster[] = res.data;

    for (const poster of posterList) {
        // delete every poster
        try {
            await axios.request({
                method: 'delete',
                maxBodyLength: Infinity,
                url: `https://komga.nelim.org/api/v1/books/${book.id}/thumbnails/${poster.id}`,
                headers: {
                    'X-API-Key': API,
                },
            });
        }
        catch (_e) {
            /**/
        }
    }

    // add and mark selected
    const data = new FormData();

    data.append('file', createReadStream(cover.imagePath));

    await axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${book.id}/thumbnails?selected=true`,
        headers: {
            'Content-Type': 'multipart/form-data',
            Accept: 'application/json',
            'X-API-Key': API,
            ...data.getHeaders(),
        },
        data,
    });
};

const updateListSeriesCover = async (
    series: Series,
    cover: ReadlistCoverInfo,
): Promise<void> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/series/${series.id}/thumbnails`,
        headers: {
            Accept: 'application/json',
            'X-API-Key': API,
        },
    });

    const posterList: SeriesPoster[] = res.data;

    for (const poster of posterList) {
        // delete every poster
        try {
            await axios.request({
                method: 'delete',
                maxBodyLength: Infinity,
                url: `https://komga.nelim.org/api/v1/series/${series.id}/thumbnails/${poster.id}`,
                headers: {
                    'X-API-Key': API,
                },
            });
        }
        catch (_e) {
            /**/
        }
    }

    // add and mark selected
    const data = new FormData();

    data.append('file', createReadStream(cover.imagePath));

    await axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/series/${series.id}/thumbnails?selected=true`,
        headers: {
            'Content-Type': 'multipart/form-data',
            Accept: 'application/json',
            'X-API-Key': API,
            ...data.getHeaders(),
        },
        data,
    });
};

const setBookMetadata = async (
    i: number,
    source: Book,
    target: Book,
): Promise<void> => {
    let newTitle = source.seriesTitle;

    if (source.seriesTitle === 'List Redirects') {
        newTitle = 'Redirect';
    }
    else {
        const thisSeries = (await getSeries(source.seriesTitle))[0];

        if (thisSeries.booksCount !== 1) {
            newTitle += ` #${source.metadata.number}`;
        }

        if (
            source.metadata.title &&
            source.metadata.title !== thisSeries.name &&
            source.metadata.title !== `Issue #${source.metadata.number}`
        ) {
            newTitle += `: ${source.metadata.title}`;
        }
    }

    source.metadata.title = newTitle;

    source.metadata.number = i.toString();
    source.metadata.numberSort = i;

    const metadata = JSON.stringify({
        ...source.metadata,
        titleLock: true,
        summaryLock: true,
        numberLock: true,
        numberSortLock: true,
        releaseDateLock: true,
        authorsLock: true,
        tagsLock: true,
        isbnLock: true,
        linksLock: true,
    } satisfies BookMetadata);

    await axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${target.id}/metadata`,
        headers: {
            'Content-Type': 'application/json',
            'X-API-Key': API,
        },
        data: metadata,
    });

    const cover = await getBookCover(source);

    await updateBookCover(target, cover);

    rmSync(cover.imagePath);
};

const setListSeriesMetadata = async (
    source: ReadList,
    target: Series,
): Promise<void> => {
    const metadata = JSON.stringify({
        ...target.metadata,
        title: `[List] ${source.name}`,
        titleLock: true,
        titleSort: `[List] ${source.name}`,
        titleSortLock: true,
        summary: source.summary,
        summaryLock: true,
    } satisfies SeriesMetadata);

    await axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/series/${target.id}/metadata`,
        headers: {
            'Content-Type': 'application/json',
            'X-API-Key': API,
        },
        data: metadata,
    });

    const cover = await getReadlistCover(source.id);

    await updateListSeriesCover(target, cover);

    rmSync(cover.imagePath);
};

const getListBooks = async (
    listKeyOrId: string,
): Promise<{
    list: ReadList;
    seriesPath: string;
    listBooks: Book[];
}> => {
    let listId = listKeyOrId;

    const listMappings = readNeighborFile('lists.json') as ListsJson;

    // support giving key instead of ID
    if (Object.keys(listMappings).includes(listKeyOrId)) {
        listId = listMappings[listKeyOrId].readlistId;
    }

    const list = await getListInfo(listId);
    const ids = list.bookIds;
    const seriesPath = `/data/comics/[List] ${list.name}`;

    const listBooks = [] as Book[];

    for (let i = 0; i < ids.length; i++) {
        const book = await getBookInfo(ids[i]);

        listBooks[i] = book;
    }

    return { list, seriesPath, listBooks };
};

// ---------------
// Main Functions
// ---------------

const getKnownLists = () => {
    return Object.keys(readNeighborFile('lists.json') as ListsJson);
};

const onceOrAll = async (id: string, func: (id: string) => Promise<void>) => {
    if (id === 'all') {
        for (const key of getKnownLists()) {
            await func(key);
        }
    }
    else {
        func(id);
    }
};

const copyListBooks = async (id: string) => {
    const { seriesPath, listBooks } = await getListBooks(id);

    rmSync(seriesPath, { recursive: true, force: true });
    mkdirSync(seriesPath, { recursive: true });

    for (const book of listBooks) {
        const bookPath = book.url;
        const inListPath = `${seriesPath}/${basename(bookPath)}`;

        console.log(`hardlinking ${basename(bookPath)}`);
        linkSync(bookPath, inListPath);
    }

    scanLibrary();
};

const transferListMetadata = async (id: string) => {
    const { list, seriesPath, listBooks } = await getListBooks(id);

    const seriesBooks = await getSeriesBooks(`[List] ${list.name}`, seriesPath);

    for (const target of seriesBooks) {
        const source = listBooks.find(
            (b) => basename(b.url) === basename(target.url),
        );

        if (source) {
            const i = listBooks.indexOf(source) + 1;

            console.log(`Setting metadata for ${source.name}`);
            setBookMetadata(i, source, target);
        }
    }

    if (seriesBooks.length > 0) {
        const thisSeries = (await getSeries(seriesBooks[0].seriesTitle))[0];

        setListSeriesMetadata(list, thisSeries);
    }
};

const saveListToFile = async (id: string) => {
    const listMappings = readNeighborFile('lists.json') as ListsJson;

    if (!(id in listMappings)) {
        process.exit(1);
    }

    console.log(`Saving ${id}`);

    const { listBooks } = await getListBooks(id);

    const output = [] as { series: string; title: string; number: number }[];

    listBooks.forEach((book) => {
        output.push({
            series: book.seriesTitle,
            title: book.metadata.title,
            number: book.metadata.numberSort,
        });
    });

    listMappings[id].issues = output;
    writeToNeighborFile(
        'lists.json',
        `${JSON.stringify(listMappings, null, 4)}\n`,
    );

    console.log(`Saved ${id}`);
};

const restoreList = async (id: string) => {
    const listMappings = readNeighborFile('lists.json') as ListsJson;

    if (!(id in listMappings)) {
        process.exit(1);
    }

    const listData = listMappings[id];
    const cvIssueLinks = listData.issues;

    const bookIds = [] as string[];

    for (let i = 0; i < cvIssueLinks.length; ++i) {
        const { series, title, number } = cvIssueLinks[i];

        const seriesSearch = (
            await axios.request({
                method: 'post',
                maxBodyLength: Infinity,
                url: 'https://komga.nelim.org/api/v1/series/list?unpaged=true',
                headers: {
                    'Content-Type': 'application/json',
                    Accept: 'application/json',
                    'X-API-Key': API,
                },
                data: JSON.stringify({
                    condition: {
                        title: {
                            operator: 'is',
                            value: series,
                        },
                    },
                }),
            })
        ).data.content;

        const bookSearch = [] as Book[];

        for (const seriesResult of seriesSearch) {
            const seriesId = seriesResult.id;

            bookSearch.push(
                ...((
                    await axios.request({
                        method: 'post',
                        maxBodyLength: Infinity,
                        url: 'https://komga.nelim.org/api/v1/books/list?unpaged=true',
                        headers: {
                            'Content-Type': 'application/json',
                            Accept: 'application/json',
                            'X-API-Key': API,
                        },
                        data: JSON.stringify({
                            condition: {
                                seriesId: {
                                    operator: 'is',
                                    value: seriesId,
                                },
                                title: {
                                    operator: 'is',
                                    value: title,
                                },
                            },
                        }),
                    })
                ).data.content as Book[]),
            );
        }

        const matchingBooks = bookSearch.filter(
            (b) =>
                b.metadata.title === title && b.metadata.numberSort === number,
        );

        if (matchingBooks.length === 0) {
            const list = await getListInfo(listData.readlistId);
            console.error(matchingBooks, number);
            throw new Error(
                `No issue matched the title '${title}' from ${series} in list ${list.name}`,
            );
        }

        if (matchingBooks.length !== 1) {
            const list = await getListInfo(listData.readlistId);
            console.error(matchingBooks, number);
            throw new Error(
                `More than one issue matched the title '${title}' from ${series} in list ${list.name}`,
            );
        }

        bookIds[i] = matchingBooks[0].id;
    }

    await axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/readlists/${listData.readlistId}`,
        headers: {
            'Content-Type': 'application/json',
            Accept: 'application/json',
            'X-API-Key': API,
        },
        data: JSON.stringify({
            bookIds,
            ordered: true,
        }),
    });

    console.log(`Restored ${id}.`);
};

const main = async (): Promise<void> => {
    if (process.argv[2] === 'ls') {
        getKnownLists().forEach((key) => {
            console.log(key);
        });
    }
    else if (process.argv[2] === 'save') {
        onceOrAll(process.argv[3], saveListToFile);
    }
    else if (process.argv[2] === 'copy') {
        onceOrAll(process.argv[3], copyListBooks);
    }
    else if (process.argv[2] === 'meta') {
        onceOrAll(process.argv[3], transferListMetadata);
    }
    else if (process.argv[2] === 'restore') {
        onceOrAll(process.argv[3], restoreList);
    }
    else if (process.argv[2] === 'json') {
        const { listBooks } = await getListBooks(process.argv[3]);

        const output = [] as {
            series: string;
            title: string;
            number: number;
        }[];

        listBooks.forEach((book) => {
            output.push({
                series: book.seriesTitle,
                title: book.metadata.title,
                number: book.metadata.numberSort,
            });
        });

        console.log(JSON.stringify(output, null, 4));
    }
    else {
        console.error('Arguments not recognized.');
        process.exit(1);
    }
};

main();
