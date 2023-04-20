// Based on https://processing.org/tutorials/sound

import processing.sound.*;
import themidibus.*;


TriOsc triOsc;
MidiBus midiBus;
SoundFile tickSound;

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
int lastNote = -1;
float lastNoteEndTime;

boolean outputMidi = true;


void setup() {
  size(640, 360);
  background(255);

  if (outputMidi) {
    // List all midi devices
    //MidiBus.list();
    midiBus = new MidiBus(this, -1, "SOUND");
    tickSound = new SoundFile(this, "tick.wav");
  } else {
    // Create triangle wave and start it
    triOsc = new TriOsc(this);
  }
  
  scale = MINOR_SCALE;
  notesInKey = getScaleNotes(rootNote, scale);

  change();
  
  frameRate(120);
}

void change() {
  boolean shouldGoBackToLastBar = previousBar != null && random(1) <= PROBABILITY_OF_GOING_BACK_TO_PREVIOUS_BAR;
  
  if (shouldGoBackToLastBar) {
    println("going back to previous");
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
  if (millis() >= nextStepTime) {
    
    if (outputMidi && playHead%2 == 0) tickSound.play();
    
    if (lastNote >= 0 && millis() >= lastNoteEndTime) { 
      midiBus.sendNoteOff(0, lastNote, 127);
      lastNote = -1;
    }
    
    Step currentStep = currentBar[playHead];
    
    print(playHead + "  ");
    
    if (currentStep != null) {
      float noteDuration = STEP_DURATION * currentStep.duration / 1000;
      
      if (outputMidi) {
        midiBus.sendNoteOn(0, currentStep.note, 127);
        lastNote = currentStep.note;
        lastNoteEndTime = millis() + noteDuration;
      } else {
        try {
          triOsc.play(midiToFreq(currentStep.note), 0.5);
          // Create the envelope
          Env env = new Env(this);
          env.play(triOsc, attackTime / currentStep.duration, noteDuration, sustainLevel, releaseTime / currentStep.duration);
        } catch (Exception e) {}
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

void exit(){
  if (lastNote >= 0) midiBus.sendNoteOff(0, lastNote, 127);
  super.exit();
}
