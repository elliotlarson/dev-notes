# Youtube DL Notes

With [youtube-dl](https://rg3.github.io/youtube-dl/) you can download videos and audio from Youtube.

## Installation

```bash
$ brew install youtube-dl
```

If you want to do audio conversion into MP3, you'll need `ffmpeg`

```bash
$ brew install ffmpeg
```

## Downloading only an audio file

```bash
$ youtube-dl -x -f bestaudio --audio-format mp3 <url-id>
```

For example

```bash
$ youtube-dl -x -f bestaudio --audio-format mp3 ZNbVtrgcsI8
```

