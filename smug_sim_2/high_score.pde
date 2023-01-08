int numHighScores = 10;
int[] highScores;



void initHighScores() {
  highScores = new int[numHighScores];
  for(int i = 0; i < highScores.length; i++) {
    highScores[i] = 0;
  }
  if(loadStrings("high scores.txt") == null) {}
  else {
    String[] temp = loadStrings("high scores.txt");
    for(int i = 0; i < temp.length && i < highScores.length; i++) {
      highScores[i] = int(temp[i]);
    }
  }
}

int winNumber = 10;
void submitHighScore(int ths) {
  for(int i = 0; i < highScores.length; i++) {
    if(ths > highScores[i]) {
      winNumber = i;
      for(int j = highScores.length-1; j > i; j--) {
        highScores[j] = highScores[j-1];
      }
      highScores[i] = ths;
      saveHighScores();
      i+=highScores.length;
    }
  }
}

void saveHighScores() {
  String[] ths = new String[highScores.length];
  for(int i = 0; i < ths.length; i++) {
    ths[i] = ""+highScores[i];
  }
  saveStrings("data/high scores.txt", ths);
}



float highScoreStartY = 720/12, highScoreSpaceY = 720/16, highScoreTextSize = 720/24;
void dispHighScores() {
  fill(0, 128, 0, 96);
  rect(470, highScoreStartY-20, 340, highScoreStartY+(highScores.length+1)*highScoreSpaceY+highScoreTextSize);
  textAlign(CENTER, TOP);
  fill(255, 64, 64);
  textSize(highScoreTextSize);
  text("HIGH SCORES", width/2, highScoreStartY);
  text("press 'U' to play again", width/2, highScoreStartY+(highScores.length+1)*highScoreSpaceY);
  for(int i = 0; i < highScores.length; i++) {
    if(winNumber == i) { fill(64, 255, 255); }
    else { fill(255, 64, 255); }
    String thstt = ""+highScores[i]; while(thstt.length() < scoreDigits) { thstt = "0"+thstt; }
    String pref = "#"+str(i+1)+"   "; if(i+1<10) { pref = " "+pref; }
    text(pref + thstt, width/2, highScoreStartY+(i+1)*highScoreSpaceY);
  }
}
