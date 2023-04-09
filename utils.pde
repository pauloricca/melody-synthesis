// This helper function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}

int getRandomIntEntry(ArrayList<Integer> list) {
  return list.get(floor(random(list.size())));
}
