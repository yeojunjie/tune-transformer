//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Tune Transformer Plugin
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.2
import MuseScore 3.0
import "TuneTransformer.js" as TuneTransformer

MuseScore {
    version: "3.4.2.1"
    description: qsTr("This is a plugin that shifts the notes of a melody to fit given chords.")
    menuPath: "Plugins." + qsTr("Tune Transformer")

    onRun: {

        // Determine how many staves are in the score.
        const numStaves = curScore.nstaves;

        // We assume that each staff has four voices even if they are not all used.
        const numVoices = 4;

        var mostRecentChordSymbol = null; // A String.

        // We use a segment to iterate through the score.
        var segment = curScore.firstSegment();
        
        // For each segment in the score, ...
        while (segment !== null) {

            const isSegmentOnStrongBeat = TuneTransformer.isSegmentOnStrongBeat(segment);

            // Check if this segment contains a chord symbol.
            var annotations = segment.annotations;
            for (var annotationIndex in annotations) {
                var annotation = annotations[annotationIndex];
                if (annotation.name === "Harmony") {
                    if (annotation.text === "N.C.") {
                        // Handle the case where the chord symbol is "N.C.", which means "no chord".
                        mostRecentChordSymbol = null;
                        continue;
                    } else {
                        // Update the most recent chord symbol.
                        mostRecentChordSymbol = annotation.text;
                    }
                }
            }

            // Process each note across all chords, voices, and staves.
            for (var staff = 0; staff < numStaves; staff++) {
                for (var voice = 0; voice < numVoices; voice++) {

                    // Get the current element at the current staff and voice.
                    const trackNumber = (staff * numVoices) + voice;
                    const currentElement = segment.elementAt(trackNumber);

                    // If there is no element at this cursor position or if the element is not a chord, continue.
                    if (!currentElement || currentElement.type !== Element.CHORD) {
                        continue;
                    }

                    // Process each note in the chord (not to be confused with chord symbol).
                    var notesInChord = currentElement.notes;
                    var numNotesInChord = notesInChord.length;
                    for (var i = 0; i < numNotesInChord; i++) {
                        
                        if (isSegmentOnStrongBeat === true) {
                            // If the segment is on a strong beat, then we want to snap the note to the nearest chord tone.
                            TuneTransformer.snapNoteToNearestChordTone(notesInChord[i], mostRecentChordSymbol);
                        } else {
                            // Else, we want to snap the note to the nearest scale tone.
                            var scaleTones = TuneTransformer.getScaleForChord(mostRecentChordSymbol);
                            TuneTransformer.snapNoteToNearestScaleTone(notesInChord[i], scaleTones);
                        }

                        // If the current note is the last note of a chain of tied notes, shift all the other notes, i.e. the earlier notes, in the
                        // chain of tied notes to the same pitch as the current note.
                        if (TuneTransformer.isNoteTheLastNoteInTieChain(notesInChord[i])) {
                            TuneTransformer.repitchEarlierNotesInTieChain(notesInChord[i]);
                        }

                    }
                }
            }

            // Advance to the next segment.
            segment = segment.next;

        }

        // Terminate the plugin.
        Qt.quit();

    } // end onRun
}
