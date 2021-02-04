# Hataraku Saibou!!

## Building

This project uses [SubKt](https://github.com/Myaamori/SubKt) for merging and muxing. To use it yourself:

1. Ensure you have a recent version of the JDK installed (11 or later).
2. Copy the `sub.properties.sample` file into `sub.properties`.
3. Edit the `FONTSDIR=` line to point to your fonts location. The structure should follow the structure outlined below:

```bash
$FONTSDIR
├── 01
│   └── bar.ttf
├── 02
│   └── xyzzy.otf
├── common
│   └── foo.ttf
├── ED
│   ├── baz.otf
│   └── baz-bold.otf
└── OP
    └── qux.ttf
```

The `common` directory is meant for fonts that are used in every episode, such as the dialogue font. This is purely for convenience and does not necessarily need to be adhered to. In the example above, both episodes 01 and 02 would have `foo.ttf`, `baz.otf`, `baz-bold.otf`, and `qux.ttf` muxed in (assuming each has an OP and ED), and additionally 01 would have `bar.ttf` and 02 would have `xyzzy.otf`.

Run `./gradlew mux.${EPISODE}` (e.g. `./gradlew mux.01`) to merge the scripts and mux the episode. The resulting file will be placed in `dist/`.

You can also run `./gradlew merge.${EPISODE}` to only merge the scripts. The resulting ASS file will also be placed in `dist/`.

Note that the video file to be used should be named `Hataraku Saibou 2 - ${EPISODE} (Premux).mkv`, and reside in the same directory as the corresponding ASS files.

SubKt will automatically determine which tasks, if any, need to be redone, based on if the source files have changed. However, if the muxed file is deleted and no sources have changed, it will not notice that the file is missing. In this case, you can run it with `--rerun-tasks` to force all tasks to be re-executed.

### Rendering the OP and ED templates

The song styling is created using karaoke templates. The OP uses [0x.KaraTemplater](https://github.com/The0x539/Aegisub-Scripts) and the [0x.color](https://gist.github.com/The0x539/4e887675fa8378ed0a9da6b6c5576143) library. The ED uses the [KaraOK](https://github.com/logarrhythmic/karaOK) templater. Note that both rely on the `ln.kara` library from KaraOK.

## Creating info boxes

[`petzku.CellsBox.lua`](https://github.com/petzku/Aegisub-Scripts#cells-box) is a utility that can be used as an aid to generating info boxes.

## Preparing new episodes

Use the `fetch-episode.sh` shell script to create the Dialogue and Signs ASS scripts in an episode folder.
The script makes many assumptions about its input and will likely only work properly with scripts from SubsPlease.

The script requires `curl` and `xz` in `PATH`.

### Usage

```sh
fetch-episode.sh <url> [episode]
```

`<url>`: the URL of an xz-compressed ASS file. This file will be downloaded using `curl`.

`[episode]`: An optional episode number (e.g. `01`). The script will descend into the episode directory as the first step, allowing the script to be run at the project root rather than at the episode level.
