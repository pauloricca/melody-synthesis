import java.util.*;

// This helper function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

int getRandomIntEntry(ArrayList<Integer> list) {
  return list.get(floor(random(list.size())));
}

ArrayList<Integer> getScaleNotes(int rootNote, int[] scale) {
  ArrayList<Integer> notesList = new ArrayList<Integer>();
  
  int scalePos = 0;
  int note = rootNote;
  
  do {
    notesList.add(note);
    note += scale[scalePos];
    scalePos = scalePos < scale.length - 1 ? scalePos + 1 : 0;
  } while (note <= MAX_NOTE);
  
  do {
    if (note != rootNote) notesList.add(note);
    note -= scale[scalePos];
    scalePos = scalePos > 0 ? scalePos - 1 : scale.length - 1;
  } while (note >= MIN_NOTE);

  Collections.sort(notesList);  

  return notesList;
}
