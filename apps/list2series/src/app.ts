import axios from 'axios';
import { copyFileSync, mkdirSync, readFileSync, rmSync } from 'fs';
import { basename } from 'path';

// eslint-disable-next-line
type Book = any;

const API = JSON.parse(
    readFileSync(`${process.env.FLAKE}/apps/list2series/.env`, { encoding: 'utf-8' }),
).API;

// Examples of calling this script:
// $ just l2s copy 0K65Q482KK7SD
// $ just l2s meta 0K65Q482KK7SD
const LIST_ID = process.argv[3];

const getListInfo = async() => {
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

const getSeriesBooks = async(listName: string, seriesPath: string): Promise<Book[]> => {
    const series = await axios.request({
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
                    operator: 'isNot',
                    value: '',
                },
            },
        }),
    });

    const seriesId = (series.data.content as Book[]).find((s) => s.url === seriesPath).id;

    // Reset Series metadata
    axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/series/${seriesId}/metadata`,
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
                    value: seriesId,
                },
            },
        }),
    });

    return books.data.content;
};

const getBookInfo = async(id: string) => {
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

const scanLibrary = async() => {
    return await axios.request({
        method: 'post',
        maxBodyLength: Infinity,
        url: 'https://komga.nelim.org/api/v1/libraries/0K4QG58XA29DZ/scan',
        headers: {
            'X-API-Key': API,
        },
    });
};

const setBookMetadata = async(i: number, source: Book, target: Book) => {
    source.metadata.title = `${source.seriesTitle} Issue #${source.number}`;
    source.metadata.number = i.toString();
    source.metadata.numberSort = i;

    const metadata = JSON.stringify(source.metadata);

    const res = await axios.request({
        method: 'patch',
        maxBodyLength: Infinity,
        url: `https://komga.nelim.org/api/v1/books/${target.id}/metadata`,
        headers: {
            'Content-Type': 'application/json',
            'X-API-Key': API,
        },
        data: metadata,
    });

    return res;
};

const main = async() => {
    const list = await getListInfo();
    const ids = list.bookIds as string[];
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

            console.log(`copying ${basename(bookPath)}`);
            copyFileSync(bookPath, inListPath);
        }

        await scanLibrary();
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
