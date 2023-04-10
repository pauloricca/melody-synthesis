// Based on https://processing.org/tutorials/sound

import processing.sound.*;
import themidibus.*;

TriOsc triOsc;

Step[] currentBar;
Step[] previousBar;
int playHead = 0;

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 1;
float sustainLevel = 0.3;
float releaseTime = 0.2;

int barCount;
int nextBarChange;
int rootNote = 54;
int[] scale;
ArrayList<Integer> notesInKey;

// This variable stores the point in time when the next note should be triggered
int nextStepTime = millis();

boolean outputMidi = true;


void setup() {
  size(640, 360);
  background(255);

  // Create triangle wave and start it
  if (outputMidi) {
    
  } else {
    triOsc = new TriOsc(this);
  }
  
  scale = MINOR_SCALE;
  notesInKey = getScaleNotes(rootNote, scale);

  change();
  
  frameRate(120);
}

void change() {
  boolean shouldGoBackToLastBar = previousBar != null && random(1) <= PROBABILITY_OF_CHANGING_ONLY_ONE_NOTE_FROM_LAST_BAR;
  
  if (shouldGoBackToLastBar) {
    println("going back to last bar");
    Step[] swapTemp = currentBar;
    currentBar = previousBar;
    previousBar = swapTemp;
  } else {
    previousBar = currentBar;
    currentBar = getBar(currentBar);
  }
  nextBarChange = getNextBarChange();
  barCount = 0;

  for(int i = 0; i < BAR_LENGTH; i++) {
    if (currentBar[i] != null) print("(" + i + ": " + currentBar[i].note + " " + currentBar[i].duration + ") ");
    else print("(" + i + " ) ");
  }
  
  println(' ');
}

void draw() {
  // If the determined nextStepTime matches up with the computer clock check if we should play a note.
  if (millis() > nextStepTime) {
    
    Step currentStep = currentBar[playHead];
    
    print(playHead + "  ");
    
    if (currentStep != null) {
      if (outputMidi) {
        
      } else {
        float sustainDuration = STEP_DURATION * currentStep.duration / 1000;
        triOsc.play(midiToFreq(currentStep.note), 0.5);
        // Create the envelope
        Env env = new Env(this);
        env.play(triOsc, attackTime / currentStep.duration, sustainDuration, sustainLevel, releaseTime / currentStep.duration);
      }
    }

    nextStepTime = millis() + STEP_DURATION;

    // Advance by one note in the midiSequence;
    playHead++;

    // Loop the sequence, notice the jitter
    if (playHead == BAR_LENGTH) {
      playHead = 0;
      barCount++;
      
      println(' ');
      
      if (barCount > nextBarChange) change();
    }
  }
}
