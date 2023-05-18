# tune-transformer
TuneTransformer is a MuseScore 3.x plugin that shifts the notes of a melody to fit given chords.

## Installation and Usage
General instructions for installing and using plugins can be found [here](https://musescore.org/en/handbook/3/plugins).

Place `tune-transformer.qml` and `tune-transformer.js` in the folder for plugins.

The plugin will only work on scores with a chord symbol at the beginning of the score.

## Credits

This plugin relies heavily on the [ExpandChordSymbols](https://github.com/markshepherd/ExpandChordSymbols) plugin's calculation of which notes belong in a given chord.

# Developer Notes

## Cursors vs. Segments
Instead of cursors, segments are used as the main way to navigate throughout the score. This is because, for some reason, in the code below which uses cursors, `Line A` causes all but the first segment to be skipped.

```
// For each segment in the score, ...
do {
    console.log("Current segment: " + cursor.tick);

    for (var staff = 0; staff < numStaves; staff++) {
        console.log("Current staff: " + staff);
        cursor.staff = staff;

        for (var voice = 0; voice < numVoices; voice++) {
            console.log("Current voice: " + voice);
            cursor.setVoice(voice); // Line A
        }
            
    }

} while (cursor.next()); // (returns false at the last segment)
```

## One `.js` File

I had to put all the code in one `.js` file because it seems that MuseScore allows imports in `.qml` files but not in `.js` files.

Otherwise, I would have separated my code from the code I took from the ExpandChordSymbols plugin.