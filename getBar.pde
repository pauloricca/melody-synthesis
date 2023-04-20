Step[] getBar(Step[] currentBar) {
  Step[] bar = new Step[BAR_LENGTH];
  
  int pos = 0;
  
  boolean shouldCopyHalfOfLastBar = currentBar != null && random(1) <= PROBABILITY_OF_COPYING_HALF_OF_LAST_BAR;
  boolean shouldUseLastBarsRhythm = currentBar != null && random(1) <= PROBABILITY_OF_USING_LAST_BARS_RHYTHM;
  boolean shouldChangeOnlyOneNoteFromLastBar = currentBar != null && random(1) <= PROBABILITY_OF_CHANGING_ONLY_ONE_NOTE_FROM_LAST_BAR;
  
  if (shouldUseLastBarsRhythm) {
    println("using last rhythm with different notes");
  }
  
  if (shouldChangeOnlyOneNoteFromLastBar) {
    println("changing only one note");
    
    // decide which step to change
    ArrayList<Integer> allNotesInLastBar = new ArrayList<Integer>();
    for(int i = 0; i < BAR_LENGTH; i++) if (currentBar[i] != null) allNotesInLastBar.add(i);
    int stepToChange = getRandomIntEntry(allNotesInLastBar);
    
    for(pos = 0; pos < BAR_LENGTH; pos++)
      bar[pos] = currentBar[pos] != null 
        ? new Step(pos == stepToChange ? getNote(bar, pos) : currentBar[pos].note, currentBar[pos].duration) 
        : null;
  }
  
  // Should we keep half of the previous bar?
  if (shouldCopyHalfOfLastBar) {
    println("repeating first half of last");
    while(pos <= BAR_LENGTH / 2) {
      if(currentBar[pos] != null) {
        bar[pos] = currentBar[pos];
        pos += currentBar[pos].duration;
      } else {
        pos += 1;
      }
    }
  }
  
  while(pos < BAR_LENGTH) {
    float duration = shouldUseLastBarsRhythm ? 
      (currentBar[pos] == null ? 0 : currentBar[pos].duration) 
      : getDuration(BAR_LENGTH - pos);

    // silence (duration == 0)?
    if (duration > 0) {
      bar[pos] = new Step(getNote(bar, pos), duration);
      pos += duration;
    } else {
      pos += 1;
    }
  }
  
  return bar;
};

// Returns a note duration (or 0 for silence) based on the probability weights
float getDuration(float maxDuration) {
  // Generate an array list with as many entries of silence and durations as their probability weight
  ArrayList<Integer> allDurations = new ArrayList<Integer>();
  for(int i = 0; i < SILENCE_PROBABILITY_WEIGHT; i++)
    allDurations.add(0);

  for(int s = 0; s < STEP_SIZE_PROBABILITY_WEIGHTS.length; s++)
    if (STEP_SIZES[s] <= maxDuration)
      for(int i = 0; i < STEP_SIZE_PROBABILITY_WEIGHTS[s]; i++)
        allDurations.add(STEP_SIZES[s]);
  
  return getRandomIntEntry(allDurations);
}

int getNextBarChange() {
  // Generate an array list with as many entries of silence and durations as their probability weight
  ArrayList<Integer> allBarChanges = new ArrayList<Integer>();
  for(int c = 0; c < BAR_CHANGE_PROBABILITY_WEIGHTS.length; c++)
      for(int i = 0; i < BAR_CHANGE_PROBABILITY_WEIGHTS[c]; i++)
        allBarChanges.add(c);
  
  return getRandomIntEntry(allBarChanges);
}
