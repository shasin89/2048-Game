/*Author:Shasindran Poonudurai
  Title:My version of 2048 game
*/

//below are the definitions of variable and 4x4 board grid
int [][] board = new int [4][4];
int padding= 20, blockSize= 100, len = padding*(board.length+1)+blockSize*board.length;
int score = 0, MovePossible =0;
int right,down;
boolean C_pressed = false;


void setup(){
  size(500,700); //size(len,len);
  restart();
};

//empty the grid when the user request restart
void restart(){
  board = new int[4][4];
  score = 0;
  MovePossible = 1;
  generateBlock();                  //first block
  generateBlock();                  //second block
  C_pressed = false;
  //board[0][0]=1024;               //test for when the game is won
  //board[0][3]=1024;
  
};


//draw the board
void draw(){
  
  background(color(255,228,155));
  //rectangle(0,0,width,height,10,color(255,228,155));//color in rgb
  
  for(int j = 0; j < board.length; j++){
    for(int i = 0; i < board.length; i++){
      float x = padding+(padding+blockSize)*i;
      float y = padding+(padding+blockSize)*j;
      rectangle(x,y, blockSize, blockSize, 5, color(255, 255, 255));
     
     //change the block color and text when > 0
      if(board[j][i] > 0){
        changeBlockColor(j,i,x,y,blockSize, blockSize, 5);
        changeBlockText(CENTER, ""+board[j][i], x , y+22, blockSize, blockSize, 36);
      }
    }
  }
  
  updateScore(score);
  textGameOver(MovePossible);
  textYouWon(CheckYouWon());
  text("Press 'r' to restart",0,600,400,150);
  
  
};

//function that draws rectangle
void rectangle (float rec_x, float rec_y, float rec_width, float rec_height, float radius, color clr){
  fill(clr);
  rect(rec_x,rec_y,rec_width,rec_height,radius);
  
};

//function that changes the color of blocks if not empty
void changeBlockColor (int count_x,int count_y,float x_rect, float y_rect, float width_rect, float height_rect,float radius_rect){
    float powerOf2 = log(board[count_x][count_y])/log(2);
    rectangle (x_rect,y_rect,width_rect,height_rect,radius_rect, color(255-powerOf2*255/11, powerOf2*255/11, 0));
};

//function that change the text of the blocks if not empty
void changeBlockText(int align, String text_string,float text_x, float text_y, float text_width, float text_height, float text_Size){
  fill(color(0));
  textAlign(align);
  textSize(text_Size);
  text(text_string, text_x,text_y,text_width,text_height);
};


//function that draws updateScore
void updateScore (int score){
  fill(color(0));
  text("Score: "+score,30,700-150,250,150);
  textSize(36);
};

//function that checks for restart condition and restarts the game if condition is met
void CheckRestartGame(){                  
  if(keyPressed){                              
         if (key == 'r' || key == 'R')
            restart();
      }
}


//function that draws 'GameOver' text if the condition is met
void textGameOver(int moveposs){          
if(moveposs == 0){
      fill(color(0));
      text("Gameover! Click to restart!",width/2,height/3,30);
      textSize(36);
    
      if(mousePressed)
      restart();
      CheckRestartGame();
      
    }
}



//function that draws 'you won' text
void textYouWon(boolean wonistrue){  
  if(wonistrue == true && C_pressed == false) {
      fill(color(0));
      text("YOU have WON!!!",width/2,height/3,30);
      text("Press C to continue!",width/2,height/6,30);
      textSize(36);
     
  }
}

//function that checks if the game is won
boolean CheckYouWon(){  
  boolean Won = false;
  for(int j = 0; j < board.length; j++){    
    for(int i = 0; i < board.length; i++){
      if(board[j][i] >= 2048)
        Won = true;
    }
  }
    if(keyPressed){                              
      if (key == 'c' || key == 'C')
         C_pressed = true;
      }
  return Won;
}

//play the game 
void keyPressed() {
  if(MovePossible != 0){
    switch (keyCode) {
      case 37://LEFT
          right = -1;
          down = 0;
      break;
      case 38://UP
          down =-1;
          right =0;
        break; 
      case 39://RIGHT
           right = 1;
           down = 0;
        break; 
      case 40://DOWN
           down = 1;
           right = 0;
        break; 
      default://no other keys can influence the movement
            down = 0;
           right = 0;
        break;  
      }
    
    CheckRestartGame();      //check if restart key 'r' or 'R' is pressed before slide the blocks
    movement();              //slide the block if possible
    CheckYouWon();           //check if the game is won 
    
  }
    if(NoGameOver()){        //check if game over
        MovePossible = 1;
    }else
        MovePossible = 0;
}


//function that generate random block 
void generateBlock(){                                         
  ArrayList<Integer> column = new ArrayList<Integer>();      //column
  ArrayList<Integer> row = new ArrayList<Integer>();        //row
  
  for(int j = 0; j < board.length; j++){    
    for(int i = 0; i < board.length; i++){
      if(board[j][i]== 0){                                  //remaining blocks with 0 
        column.add(i);
        row.add(j);
      }  
    }
  }
      int randnum = (int)random(0, row.size());
      int x= column.get(randnum);
      int y= row.get(randnum);
    
      if(random(0,2) < 1)                                  //generate num(2 or 4) block randomly
        board[y][x] =2;
      else
        board[y][x] =4; 
};


 //main function 
int[][] play(int UpDown, int RightLeft, boolean scoreupdate){
  int[][] backup = new int[4][4];                                          //make a backup copy of the board
  
  for(int j = 0; j < board.length; j++){    
    for(int i = 0; i < board.length; i++){
      backup[j][i] = board[j][i];
    }
  }
  
  boolean moved =false;
  
  //run play function only when either (Up,Down,Right,Left) key is pressed
  if(UpDown !=0 || RightLeft !=0){
    int step_direction = RightLeft !=0 ? RightLeft : UpDown;        

    //slide all the blocks to the corresponding directions(up,down,right,left)
    
    /*Here we check each blocks by visiting them. Lets say the user has pressed the key left(UpDown = 0,Rightleft=-1) Starting from row '0' and column '1',we check if the blocks are empty.
    If empty then skip to next column. If not empty calculate how many blocks it should slide;stop the slide if the following block in left direction is not empty. 
    Merge if the block have same number.Clear the current block if a move is made. Repeat the steps for next row or column depending on the direction    */
    
    //n-th row (n=0,1,2,4)
    for(int nth_row = 0;  nth_row < board.length; nth_row++)
      for(int nth_column = (step_direction > 0 ? board.length-2 : 1);  nth_column != (step_direction > 0 ? -1: board.length); nth_column -= step_direction){        //nth-cloumn (n=0,1,2,3)
          int y = RightLeft != 0 ? nth_row : nth_column;                //determine the coordinate xy of the block for (right and left) and (up and down)
          int x = RightLeft != 0 ? nth_column : nth_row;
          int dy = y;                                                   //change in the direction -y     
          int dx = x;                                                   //change in the direction -x 
          
          
          //if the column is zero then skip the steps to the next column
          if(backup[y][x]==0) continue;
          
            //calculate how many blocks the current block should slide in the direction
            //x and y are the current block position, tx and ty are where the block is sliding into
            for(int i = (RightLeft != 0 ? x : y)+step_direction; i != (step_direction > 0 ? board.length : -1); i+=step_direction){
              int a = RightLeft != 0 ? y : i;                          //xy-coordinate
              int b = RightLeft != 0 ? i : x;
              
              //stop the slide if blocks are not empty and the value is not equal
              if(backup[a][b] != 0 && backup[a][b] != board[y][x]) break;
            
              //change in direction
              if(RightLeft != 0) 
                  dx = i;
              else
                  dy = i;    
            }
            
            //if the block stays at the same positon;no movement in that direction,then  skip
            if((RightLeft != 0 && dx == x) || (UpDown != 0 && dy == y)) continue;
            
            
            //if the block moves into new position then merge the blocks if their number is same
            else if(backup[dy][dx] == board[y][x]){ 
              backup[dy][dx] *= 2;                                       //times 2
              if(scoreupdate) 
                score += backup[dy][dx];
                updateScore(score);
                moved =true;
               
            }
            
            //switch the block with the empty position
            else if((RightLeft != 0 && dx != x ) || (UpDown !=0 && dy != y)){ 
              backup[dy][dx] = backup[y][x];
              moved =true;
            }
            
            
            if(moved)                                
              backup[y][x]= 0;                       //clear the block
            
          }
      }
      return moved ? backup : null;
  }
  
  
//conditions to check if the game is over
boolean NoGameOver(){
  int [] Right = {1,-1,0,0}, Down = {0,0,1,-1};          //values for the up,down,left,right key.
  boolean gameover = false;
  
    for(int i=0; i < 4; i++){
      if(play(Down[i],Right[i],false) != null)           //If no movement is possible the function returns null 
        gameover = true;
    }
    return gameover;
};

//move the blocks and generate new block
boolean movement(){
    int[][] newboard  = play(down,right,true);
    if(newboard != null){
      board = newboard;
      generateBlock();
        return true;
    }else
       return false;
  }   
