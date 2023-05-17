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

MuseScore {
    version: "3.4.2.1"
    description: qsTr("This is a plugin that shifts the notes of a melody to fit given chords.")
    menuPath: "Plugins.Notes." + qsTr("Tune Transformer")

    onRun: {

        // Determine how many staves are in the score.
        const numStaves = curScore.nstaves;

        // We assume that each staff has four voices even if they are not all used.
        const numVoices = 4;

        var mostRecentChordSymbol = null;

        // Use a cursor to get the first segment.
        // Segments are used because cursors seem to be buggy. 
        // See Dev Notes in README.md.
        var cursor = curScore.newCursor();
        cursor.rewindToTick(0);
        var segment = cursor.segment;
        
        // For each segment in the score, ...
        do {
            console.log("Current tick: " + segment.tick);

            for (var staff = 0; staff < numStaves; staff++) {
                console.log("Current staff: " + staff);

                for (var voice = 0; voice < numVoices; voice++) {
                    console.log("Current voice: " + voice);

                    // Get the current element at the current staff and voice.
                    const trackNumber = (staff * numVoices) + voice;
                    var currentElement = segment.elementAt(trackNumber);

                    // If there is no element at this cursor position or if the element is not a chord, continue.
                    if (!currentElement || currentElement.type !== Element.CHORD) {
                        continue;
                    }

                    // Process each note in the chord (not to be confused with chord symbol).
                    var notesInChord = currentElement.notes;
                    var numNotesInChord = notesInChord.length;
                    for (var i = 0; i < numNotesInChord; i++) {
                        console.log(notesInChord[i].pitch);
                    }
                }
            }

            // Advance to the next segment.
            segment = segment.next;

        } while (segment !== null); // (while there is still another segment in the score)

        // Terminate the plugin.
        Qt.quit();

    } // end onRun
}
