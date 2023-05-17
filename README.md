# tune-transformer
TuneTransformer is a MuseScore 3.x plugin that shifts the notes of a melody to fit given chords.

---
## Developer Notes
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