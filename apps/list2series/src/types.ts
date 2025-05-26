export interface ListJson {
    readlistId: string
    seriesId: string
    issues: {
        series: string
        title: string
    }[]
}

export type ListsJson = Record<string, ListJson>;

export interface Media {
    status: string
    mediaType: string
    pagesCount: number
    comment: string
    epubDivinaCompatible: boolean
    epubIsKepub: boolean
    mediaProfile: string
}

export interface Author {
    name: string
    role: string
}

export interface Link {
    label: string
    url: string
}

export interface ShortBookMetadata {
    authors: Author[]
    tags: unknown[]
    releaseDate: string
    summary: string
    summaryNumber: string
    created: string
    lastModified: string
}

export interface BookMetadata {
    title: string
    titleLock: boolean
    summary: string
    summaryLock: boolean
    number: string
    numberLock: boolean
    numberSort: number
    numberSortLock: boolean
    releaseDate: string
    releaseDateLock: boolean
    authors: Author[]
    authorsLock: boolean
    tags: unknown[]
    tagsLock: boolean
    isbn: string
    isbnLock: boolean
    links: Link[]
    linksLock: boolean
    created: string
    lastModified: string
}

export interface Book {
    id: string
    seriesId: string
    seriesTitle: string
    libraryId: string
    name: string
    url: string
    number: number
    created: string
    lastModified: string
    fileLastModified: string
    sizeBytes: number
    size: string
    media: Media
    metadata: BookMetadata
    readProgress: null | unknown
    deleted: boolean
    fileHash: string
    oneshot: boolean
}

export interface SeriesMetadata {
    status: string
    statusLock: boolean
    title: string
    titleLock: boolean
    titleSort: string
    titleSortLock: boolean
    summary: string
    summaryLock: boolean
    readingDirection: string
    readingDirectionLock: boolean
    publisher: string
    publisherLock: boolean
    ageRating: null | string
    ageRatingLock: boolean
    language: string
    languageLock: boolean
    genres: string[]
    genresLock: boolean
    tags: unknown[]
    tagsLock: boolean
    totalBookCount: null | number
    totalBookCountLock: boolean
    sharingLabels: unknown[]
    sharingLabelsLock: boolean
    links: Link[]
    linksLock: boolean
    alternateTitles: string[]
    alternateTitlesLock: boolean
    created: string
    lastModified: string
}

export interface Series {
    id: string
    libraryId: string
    name: string
    url: string
    created: string
    lastModified: string
    fileLastModified: string
    booksCount: number
    booksReadCount: number
    booksUnreadCount: number
    booksInProgressCount: number
    metadata: SeriesMetadata
    booksMetadata: ShortBookMetadata
    deleted: boolean
    oneshot: boolean
}

export interface ReadList {
    id: string
    name: string
    summary: string
    ordered: boolean
    bookIds: string[]
    createdDate: string
    lastModifiedDate: string
    filtered: boolean
}
