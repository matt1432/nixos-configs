#!/usr/bin/env node

import { Commit } from 'commit'; // Custom type
import fetch from 'node-fetch';

const DATA = {
    sha: process.env.GITHUB_SHA,
    webhook: process.argv[2],
};

const commitInfo = await (await fetch(`https://git.nelim.org/api/v1/repos/matt1432/nixos-configs/git/commits/${DATA.sha}`)).json() as Commit;

const commit = JSON.stringify({
    content: null,
    embeds: [{
        title: 'New commit containing changes to server configs:',
        description: commitInfo.commit.message,
        url: commitInfo.url,
        author: {
            name: commitInfo.author.username,
            icon_url: commitInfo.author.avatar_url,
        },
    }],
    // Diff: await (await fetch(`${last['url']}.diff`)).text()
});

const post = await fetch(`${DATA.webhook}?wait=true`, {
    method: 'post',
    body: commit,
    headers: { 'Content-Type': 'application/json' },
});

console.log(await post.text());
