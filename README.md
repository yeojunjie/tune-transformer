# tune-transformer
TuneTransformer is a MuseScore 3.x plugin that shifts the notes of a melody to fit given chords.

## Installation
Place `tune-transformer.qml` and `TuneTransformer.js` in the folder for plugins.
General instructions for installing and using plugins can be found [here](https://musescore.org/en/handbook/3/plugins).

## Usage
1. Add chord symbols on top of a melody.
2. Then, run the plugin. The plugin will shift the notes of the melody to fit the chords.
    * If a note in the melody falls on a strong beat, then the note will be shifted to the nearest note in the most recent chord.
    * If a note in the melody falls on a weak beat, then the plugin calculates a scale that fits the most recent chord, and the note in the melody will be shifted to the nearest note in that scale.

To protect a section of the melody from being shifted, add a chord symbol with the text `N.C.` (no chord) above the first note of the section. This plugin has no effect on notes that do not have a most recent chord symbol. For this reason, the plugin resumes shifting notes at the next chord symbol after the `N.C.` chord symbol.

For now, this plugin assumes that each chord symbol alters each note only once. For example, `C7b9#9` is not supported, and will be interpreted as `C7#9`.

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

## Time Signatures

It appears that time signatures can only be read from a measure and not from a segment.

```
var measure = segment.parent;
console.log(measure.timesigActual.numerator);    // The actual numerator.
console.log(measure.timesigActual.denominator);  // The actual deminominator.
console.log(segment.timesigActual.numerator);    // Always one.
console.log(segment.timesigActual.denominator);  // Always zero.
```