import { Commit } from 'commit'; // Custom type
import fetch from 'node-fetch';

const DATA = {
    env: {...process.env},
    webhook: process.argv[2], // get it from env?
};

const allCommits = await (await fetch('https://git.nelim.org/api/v1/repos/matt1432/nixos-configs/commits')).json() as Array<Commit>;

const last = allCommits[0];

const commit = JSON.stringify({
    content: null,
    embeds: [{
        title: 'New commit containing changes to server configs:',
        description: last.commit.message,
        url: last.url,
        author: {
            name: last.author.username,
            icon_url: last.author.avatar_url,
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
