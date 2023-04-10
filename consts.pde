int BAR_LENGTH = 16;

// Note durations
// 1: 1/16
// 2: 1/8
// 4: 1/4
// 8: 1/2
// 16: 1 (whole note)
int[] STEP_SIZES = {1, 2, 4, 8, 16};

// higher number means the corresponding step size  is more likely
int[] STEP_SIZE_PROBABILITY_WEIGHTS = {12, 5, 3, 2, 0};
int SILENCE_PROBABILITY_WEIGHT = 5;

int[] BAR_CHANGE_PROBABILITY_WEIGHTS = {2, 6, 0, 1};

// Rhythm probabilities
float PROBABILITY_OF_COPYING_HALF_OF_LAST_BAR = 0.3;
float PROBABILITY_OF_USING_LAST_BARS_RHYTHM = 0.3;
float PROBABILITY_OF_CHANGING_ONLY_ONE_NOTE_FROM_LAST_BAR = 0.3;
float PROBABILITY_OF_GOING_BACK_TO_PREVIOUS_BAR = 0.3;

// Note weights
float WEIGHT_OF_CONTINUING_IN_SAME_DIRECTION = 2;
float WEIGHT_OF_PLAYING_ROOT_NOTE = 2;
float WEIGHT_OF_PLAYING_ROOT_NOTE_AS_FIRST_NOTE_IN_BAR = 2;
float WEIGHT_OF_SHORT_INTERVAL = 10;
float WEIGHT_OF_INVERTING_DIRECTION_AFTER_A_LARGE_INTERVAL = 4;
float WEIGHT_OF_INVERTING_DIRECTION_AFTER_A_VERY_LARGE_INTERVAL = 10;
float WEIGHT_OF_NOTE_BEING_IN_KEY = 15;

// https://www.researchgate.net/profile/Davide-Baccherini-2/publication/221276841/figure/tbl1/AS:669024811773964@1536519353526/A-representation-of-notes-in-the-MIDI-standard.png
int MIN_NOTE = 36; // C3
int MAX_NOTE = 72; // C6

int SHORT_INTERVAL = 4; // two whole tones
int LARGE_INTERVAL = 8; // four whole tones
int VERY_LARGE_INTERVAL = 12; // six whole tones

int STEP_DURATION = 200;

int[] MAJOR_SCALE = {2, 2, 1, 2, 2, 2, 1};
int[] MINOR_SCALE = {2, 1, 2, 2, 1, 2, 2};
