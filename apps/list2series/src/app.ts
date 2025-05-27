import axios from 'axios';
import { linkSync, mkdirSync, readFileSync, rmSync } from 'fs';
import { basename } from 'path';

import {
    type Book,
    type ListsJson,
    type ReadList,
    type Series,
} from './types';


// Examples of calling this script:
// $ just l2s copy 0K65Q482KK7SD
// $ just l2s meta 0K65Q482KK7SD

const readNeighborFile = (filename: string) => JSON.parse(
    readFileSync(`${process.env.FLAKE}/apps/list2series/${filename}`, { encoding: 'utf-8' }),
);

const API = readNeighborFile('.env').API;

const getListInfo = async(listId: string): Promise<ReadList> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/readlists/${listId}`,
        headers: {
            'Accept': 'application/json',
            'X-API-Key': API,
        },
    });

    return res.data;
};

const getSeries = async(seriesTitle: string, operator = true): Promise<Series[]> => {
    return (await axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: 'https://komga.nelim.org/api/v1/series/list?unpaged=true',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
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
    })).data.content;
};

const getSeriesBooks = async(listName: string, seriesPath: string): Promise<Book[]> => {
    const thisSeries = (await getSeries('', false)).find((s) => s.url === seriesPath);

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
            'Accept': 'application/json',
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

const getBookInfo = async(id: string): Promise<Book> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${id}`,
        headers: {
            'Accept': 'application/json',
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

const setBookMetadata = async(i: number, source: Book, target: Book): Promise<void> => {
    const thisSeries = (await getSeries(source.seriesTitle))[0];

    source.metadata.title = thisSeries.booksCount !== 1 ?
        `${source.seriesTitle} Issue #${source.metadata.number}` :
        source.metadata.title = source.seriesTitle;

    source.metadata.number = i.toString();
    source.metadata.numberSort = i;

    const metadata = JSON.stringify(source.metadata);

    axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${target.id}/metadata`,
        headers: {
            'Content-Type': 'application/json',
            'X-API-Key': API,
        },
        data: metadata,
    });
};

const getListBooks = async(listId: string): Promise<{
    list: ReadList
    seriesPath: string
    listBooks: Book[]
}> => {
    const list = await getListInfo(listId);
    const ids = list.bookIds;
    const seriesPath = `/data/comics/[List] ${list.name}`;

    const listBooks = [] as Book[];

    for (let i = 0; i < ids.length; i++) {
        const book = await getBookInfo(ids[i]);

        listBooks[i] = book;
    };

    return { list, seriesPath, listBooks };
};

const main = async(): Promise<void> => {
    if (process.argv[2] === 'copy') {
        const { seriesPath, listBooks } = await getListBooks(process.argv[3]);

        rmSync(seriesPath, { recursive: true, force: true });
        mkdirSync(seriesPath, { recursive: true });

        for (const book of listBooks) {
            const bookPath = book.url;
            const inListPath = `${seriesPath}/${basename(bookPath)}`;

            console.log(`hardlinking ${basename(bookPath)}`);
            linkSync(bookPath, inListPath);
        }

        scanLibrary();
    }

    else if (process.argv[2] === 'meta') {
        const { list, seriesPath, listBooks } = await getListBooks(process.argv[3]);

        const seriesBooks = await getSeriesBooks(`[List] ${list.name}`, seriesPath);

        for (const target of seriesBooks) {
            const source = listBooks.find((b) => basename(b.url) === basename(target.url));

            if (source) {
                const i = listBooks.indexOf(source) + 1;

                console.log(`Setting metadata for ${source.name}`);
                setBookMetadata(i, source, target);
            }
        }
    }

    else if (process.argv[2] === 'json') {
        const { listBooks } = await getListBooks(process.argv[3]);

        const output = [] as { series: string, title: string }[];

        listBooks.forEach((book) => {
            output.push({
                series: book.seriesTitle,
                title: book.metadata.title,
            });
        });

        console.log(JSON.stringify(output, null, 4));
    }

    else if (process.argv[2] === 'init') {
        const listKey = process.argv[3];
        const listMappings = readNeighborFile('lists.json') as ListsJson;

        const listData = listMappings[listKey];
        const cvIssueLinks = listData.issues;

        const bookIds = [] as string[];

        for (let i = 0; i < cvIssueLinks.length; ++i) {
            const { series, title } = cvIssueLinks[i];

            const seriesSearch = (await axios.request({
                method: 'post',
                maxBodyLength: Infinity,
                url: 'https://komga.nelim.org/api/v1/series/list?unpaged=true',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
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
            })).data.content;

            const bookSearch = [] as Book[];

            for (const seriesResult of seriesSearch) {
                const seriesId = seriesResult.id;

                bookSearch.push(...((await axios.request({
                    method: 'post',
                    maxBodyLength: Infinity,
                    url: 'https://komga.nelim.org/api/v1/books/list?unpaged=true',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
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
                })).data.content as Book[]));
            }

            const matchingBooks = bookSearch.filter((b) => b.metadata.title === title);

            if (matchingBooks.length !== 1) {
                throw new Error(`More than one issue matched the title '${title}'`);
            }

            bookIds[i] = matchingBooks[0].id;
        }

        axios.request({
            method: 'patch',
            maxBodyLength: Infinity,
            url: `https://komga.nelim.org/api/v1/readlists/${listData.readlistId}`,
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-API-Key': API,
            },
            data: JSON.stringify({
                bookIds,
                ordered: true,
                // name: 'string',
                // summary: 'string',
            }),
        });

        console.log(`Updated ${listKey}.`);
    }

    else {
        console.error('Arguments not recognized.');
        exit(1);
    }
};

main();
