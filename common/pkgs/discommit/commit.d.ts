export type Commit = {
    url: string,
    sha: string,
    created: string,
    html_url: string,
    commit: {
        url: string,
        author: {
            name: string,
            email: string,
            date: string
        },
        committer: {
            name: string,
            email: string,
            date: string
        },
        message: string,
        tree: {
            url: string,
            sha: string,
            created: string
        },
        verification: {
            verified: boolean,
            reason: string,
            signature: string,
            signer: string | null,
            payload: string
        }
    },
    author: {
        id: number,
        login: string,
        login_name: string,
        full_name: string,
        email: string,
        avatar_url: string,
        language: string,
        is_admin: boolean,
        last_login: string,
        created: string,
        restricted: boolean,
        active: boolean,
        prohibit_login: boolean,
        location: string,
        website: string,
        description: string,
        visibility: string,
        followers_count: number,
        following_count: number,
        starred_repos_count: number,
        username: string
    },
    committer: {
        id: number,
        login: string,
        login_name: string,
        full_name: string,
        email: string,
        avatar_url: string,
        language: string,
        is_admin: boolean,
        last_login: string,
        created: string,
        restricted: boolean,
        active: boolean,
        prohibit_login: boolean,
        location: string,
        website: string,
        description: string,
        visibility: string,
        followers_count: number,
        following_count: number,
        starred_repos_count: number,
        username: string
    },
    parents: Array<{
        url: string,
        sha: string,
        created: string
    }>,
    files: Array<{
        filename: string,
        status: string
    }>,
    stats: { total: number, additions: number, deletions: number }
};
