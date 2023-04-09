int BAR_LENGTH = 16;

// Note durations
// 1: 1/16
// 2: 1/8
// 4: 1/4
// 8: 1/2
// 16: 1 (whole note)
int[] STEP_SIZES = {1, 2, 4, 8, 16};

// higher number means the corresponding step size  is more likely
int[] STEP_SIZE_PROBABILITY_WEIGHTS = {3, 12, 6, 3, 1};
int SILENCE_PROBABILITY_WEIGHT = 20;

int[] BAR_CHANGE_PROBABILITY_WEIGHTS = {1, 4, 0, 0}; // 6

float PROBABILITY_OF_COPYING_HALF_OF_LAST_BAR = 0.3;
float PROBABILITY_OF_USING_LAST_BARS_RHYTHM = 0.3;
float PROBABILITY_OF_CHANGING_ONLY_ONE_NOTE_FROM_LAST_BAR = 0.3;
float PROBABILITY_OF_GOING_BACK_TO_PREVIOUS_BAR = 0.3;

// https://www.researchgate.net/profile/Davide-Baccherini-2/publication/221276841/figure/tbl1/AS:669024811773964@1536519353526/A-representation-of-notes-in-the-MIDI-standard.png
int MIN_NOTE = 36; // C3
int MAX_NOTE = 72; // C6

int STEP_DURATION = 200;
