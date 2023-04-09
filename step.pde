// One step in the sequencer
class Step {
  int note; // midi note number
  float duration; // see key above
  
  Step(int note, float duration) {
    this.note = note;
    this.duration = duration;
  }
}
