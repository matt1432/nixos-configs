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

export interface Metadata {
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
    tags: []
    tagsLock: boolean
    isbn: string
    isbnLock: boolean
    links: unknown[]
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
    metadata: Metadata
    readProgress: null | unknown
    deleted: boolean
    fileHash: string
    oneshot: boolean
}
