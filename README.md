# Tune Transformer
TuneTransformer is a MuseScore 3.x plugin that shifts the notes of a melody to fit given chords. **Watch the overview video [here](https://youtu.be/4x0sDSQc2CM).**

## Installation
Click on the green **`<> Code`** button and select **Download ZIP**. Place `tune-transformer.qml` and `TuneTransformer.js` in the folder that MuseScore has been configured to look for plugins in.
General instructions for installing and using plugins can be found [here](https://musescore.org/en/handbook/3/plugins).

## Usage
1. Add chord symbols on top of a melody.
2. Then, run the plugin. The plugin will shift the notes of the melody to fit the chords.
    * If a note in the melody falls on a strong beat, then the note will be shifted to the nearest note in the most recent chord.
    * If a note in the melody falls on a weak beat, then the plugin calculates a scale that fits the most recent chord, and the note in the melody will be shifted to the nearest note in that scale.

To protect a section of the melody from being shifted, add a chord symbol with the text `N.C.` (no chord) above the first note of the section. This plugin has no effect on notes that do not have a most recent chord symbol. For this reason, the plugin resumes shifting notes at the next chord symbol after the `N.C.` chord symbol.

## Credits

This plugin relies heavily on the [ExpandChordSymbols](https://github.com/markshepherd/ExpandChordSymbols) plugin's calculation of which notes belong in a given chord.

# Known Issues
1. The plugin does not work properly for transposing instruments.
2. The plugin does a poor job of spelling notes. Currently, it always spells the note between F and G as F#, even in the context of an Eb minor chord.
3. The plugin does not support chords with multiple alterations to a single note. For example, `C7b9#9` is not supported, and will be interpreted as `C7#9`.

# Developer Notes

## Cursors vs. Segments
This plugin uses segments to navigate throughout the score. Cursors are not used because, for some reason, in the code below which uses cursors, `Line A` causes all but the first segment to be skipped.

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

            // For each chord, for each note, alter its pitch.

        }
            
    }

} while (cursor.next()); // (returns false at the last segment)
```

## One `.js` File

I had to put all the code in one `.js` file because it seems that MuseScore allows imports in `.qml` files but not in `.js` files.

Otherwise, I would have separated my code from the code I took from the ExpandChordSymbols plugin.

## Time Signatures

Time signatures are read from the measure (parent of the segment) and not from the segment itself. This is because of the following behaviour:

```
var measure = segment.parent;
console.log(measure.timesigActual.numerator);    // Prints the actual numerator.
console.log(measure.timesigActual.denominator);  // Prints the actual deminominator.
console.log(segment.timesigActual.numerator);    // Always prints one.
console.log(segment.timesigActual.denominator);  // Always prints zero.
```
