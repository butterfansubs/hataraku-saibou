# Hataraku Saibou!!

## Building

This project uses [SubKt](https://github.com/Myaamori/SubKt) for merging and muxing. To use it yourself:

1. Ensure you have a recent version of the JDK installed (11 or later).
2. Copy the `sub.properties.sample` file into `sub.properties`.
3. Edit the `FONTSDIR=` line to point to your fonts location. The structure should follow the structure of this directory:

```bash
$FONTSDIR
├── 01
│   ├── foo.ttf
│   └── bar.ttf
├── ED
│   ├── baz.otf
│   └── baz-bold.otf
└── OP
    └── qux.ttf
```

Run `./gradlew mux.${EPISODE}` (e.g. `./gradlew mux.01`) to merge the scripts and mux the episode. The resulting file will be placed in `dist/`.

You can also run `./gradlew merge.${EPISODE}` to only merge the scripts. The resulting ASS file will also be placed in `dist/`.

SubKt will automatically determine which tasks, if any, need to be redone, based on if the source files have changed. However, if the muxed file is deleted and no sources have changed, it will not notice that the file is missing. In this case, you can run it with `--rerun-tasks` to force all tasks to be re-executed.

### Rendering the OP and ED templates

The song styling is created using karaoke templates. The OP uses [0x.KaraTemplater](https://github.com/The0x539/Aegisub-Scripts) and the [0x.color](https://gist.github.com/The0x539/4e887675fa8378ed0a9da6b6c5576143) library. The ED uses the [KaraOK](https://github.com/logarrhythmic/karaOK) templater. Note that both rely on the `ln.kara` library from KaraOK.
