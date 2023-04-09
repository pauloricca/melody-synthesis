// Based on https://processing.org/tutorials/sound

import processing.sound.*;

TriOsc triOsc;

Step[] currentBar;
Step[] previousBar;
int playerHead = 0;

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 1;
float sustainLevel = 0.3;
float releaseTime = 0.2;

int barCount;
int nextBarChange;

// This variable stores the point in time when the next note should be triggered
int nextStepTime = millis();


void setup() {
  size(640, 360);
  background(255);

  // Create triangle wave and start it
  triOsc = new TriOsc(this);
  
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
    currentBar = generateBar(currentBar);
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
    
    Step currentStep = currentBar[playerHead];
    
    print(playerHead + "  ");
    
    if (currentStep != null) {
      triOsc.play(midiToFreq(currentStep.note), 0.5);
      
      float sustainDuration = STEP_DURATION * currentStep.duration / 1000;
      
      // Create the envelope
      Env env = new Env(this);
      env.play(triOsc, attackTime / currentStep.duration, sustainDuration, sustainLevel, releaseTime / currentStep.duration);
    }

    nextStepTime = millis() + STEP_DURATION;

    // Advance by one note in the midiSequence;
    playerHead++;

    // Loop the sequence, notice the jitter
    if (playerHead == BAR_LENGTH) {
      playerHead = 0;
      barCount++;
      
      println(' ');
      
      if (barCount > nextBarChange) change();
      
    }
  }
}
