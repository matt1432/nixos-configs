import axios from 'axios';
import { linkSync, mkdirSync, readFileSync, rmSync } from 'fs';
import { basename } from 'path';

import { type Book, type ReadList, type Series } from './types';


// Examples of calling this script:
// $ just l2s copy 0K65Q482KK7SD
// $ just l2s meta 0K65Q482KK7SD
const API = JSON.parse(
    readFileSync(`${process.env.FLAKE}/apps/list2series/.env`, { encoding: 'utf-8' }),
).API;

const LIST_ID = process.argv[3];

const getListInfo = async(): Promise<ReadList> => {
    const res = await axios.request({
        method: 'get',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/readlists/${LIST_ID}`,
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

const main = async(): Promise<void> => {
    const list = await getListInfo();
    const ids = list.bookIds;
    const seriesPath = `/data/comics/[List] ${list.name}`;

    const listBooks = [] as Book[];

    for (let i = 0; i < ids.length; i++) {
        const book = await getBookInfo(ids[i]);

        listBooks[i] = book;
    };

    if (process.argv[2] === 'copy') {
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
};

main();
