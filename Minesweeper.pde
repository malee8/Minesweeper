import de.bezier.guido.*;
public static final int NUM_ROWS=16;
public static final int NUM_COLS=16;
public static final int NUM_BOMBS=40;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines=new ArrayList <MSButton>();

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons=new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        buttons[r][c]=new MSButton(r,c);
      }
    }
    
    setMines();
}
public void setMines()
{
  while(mines.size()<NUM_BOMBS){
    int r=(int)(Math.random()*NUM_ROWS);
    int c=(int)(Math.random()*NUM_COLS);
    if(mines.contains(buttons[r][c])==false){
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int sum=0;
  boolean mbool=false;
  for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
      if(mines.contains(buttons[i][j])==false){
        if(buttons[i][j].clicked==true){
          sum++;
        }
      }
      else{
        if(buttons[i][j].clicked==true){
          mbool=true;
        }
      }
    }
  }
  if(sum==NUM_ROWS*NUM_COLS-NUM_BOMBS&&mbool==false){
    return true;
  }
  else{
    return false;
  }
}
public void displayLosingMessage()
{
  buttons[7][6].myLabel="L";
  buttons[7][7].myLabel="O";
  buttons[7][8].myLabel="S";
  buttons[7][9].myLabel="E";
  for(int i=0;i<NUM_ROWS;i++){
    for(int j=0;j<NUM_COLS;j++){
      buttons[i][j].flagged=false;
      buttons[i][j].clicked=true;
    }
  }
}
public void displayWinningMessage()
{
  buttons[7][6].myLabel="W";
  buttons[7][7].myLabel="I";
  buttons[7][8].myLabel="N";
}
public boolean isValid(int r, int c)
{
  if(r<NUM_ROWS&&r>-1&&c>-1&&c<NUM_COLS){
    return true;
  }
  else{
    return false;
  }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i=row-1;i<=row+1;i++){
      for(int j=col-1;j<=col+1;j++){
        if(isValid(i,j)==true&&mines.contains(buttons[i][j])){
          numMines++;
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton==RIGHT){
          if(flagged==true){
            flagged=false;
            clicked=false;
          }
          else{
            flagged=true;
          }
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow,myCol)>0){
          myLabel=countMines(myRow,myCol)+"";
        }
        else{
          for(int i=myRow-1;i<=myRow+1;i++){
            for(int j=myCol-1;j<=myCol+1;j++){
              if(isValid(i,j)==true&&buttons[i][j].clicked==false){
                buttons[i][j].mousePressed();
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(15);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
