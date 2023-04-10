int getRandomNote() {
  return floor(random(MIN_NOTE, MAX_NOTE + 1));
}

// Generates a note for a specific step, given a current bar 
int getNote(Step[] currentBar, int step) {
  // Determine previous note
  ArrayList<Integer> previousNotes = new ArrayList<Integer>();
  for(int i = 0; i < step; i++) if(currentBar[i] != null) previousNotes.add(currentBar[i].note);
  
  int lastNote = 0;
  int penultimateNote = 0;
  int lastInterval = 0;
  
  if (previousNotes.size() > 0) {
    lastNote = previousNotes.get(previousNotes.size() - 1);
  
    if (previousNotes.size() > 1) {
      penultimateNote = previousNotes.get(previousNotes.size() - 2);
      // Signed interval between previous two notes of the bar. 0 means previous notes were the same, or we don't have two notes yet. >0 means going up and <0 going down
     lastInterval = lastNote - penultimateNote;
    }
  }
  
  // For each note of the whole range generate a map of probabilities for how likely it is that we'll play that note next
  int[] allNotes = new int[MAX_NOTE - MIN_NOTE + 1];
  ArrayList<Integer> allNotesWeights = new ArrayList<Integer>();
  
  for(int i = 0; i < allNotes.length; i++) {
    int note = MIN_NOTE + i;
    int weight = 1;
    
    // Travelling in the same direction
    if (lastInterval < 0 && note < lastNote || lastInterval > 0 && note > lastNote)
      weight *= WEIGHT_OF_CONTINUING_IN_SAME_DIRECTION;
      
    // Playing root note
    if (note == rootNote) {
      weight *= WEIGHT_OF_PLAYING_ROOT_NOTE;
      
      // ... as first note in bar
      if (lastNote == 0)
        weight *= WEIGHT_OF_PLAYING_ROOT_NOTE_AS_FIRST_NOTE_IN_BAR;
    }
    
    // Short interval
    if (abs(note - lastNote) <= SHORT_INTERVAL)
      weight *= WEIGHT_OF_SHORT_INTERVAL;
    
    // Invert direction after large interval
    if (lastInterval >= LARGE_INTERVAL && note < lastNote || -lastInterval <= -LARGE_INTERVAL && note > lastNote) {
      weight *= WEIGHT_OF_INVERTING_DIRECTION_AFTER_A_LARGE_INTERVAL;
      
      /// ... very large interval?
      if (lastInterval >= VERY_LARGE_INTERVAL && note < lastNote || -lastInterval <= -VERY_LARGE_INTERVAL && note > lastNote) {
        weight *= WEIGHT_OF_INVERTING_DIRECTION_AFTER_A_VERY_LARGE_INTERVAL;
      }
    }
    
    // In key
    if (notesInKey.contains(note))
      weight *= WEIGHT_OF_NOTE_BEING_IN_KEY;
    
    for(int w = 0; w < weight; w++) allNotesWeights.add(note);
  }
  
  return getRandomIntEntry(allNotesWeights);
}
