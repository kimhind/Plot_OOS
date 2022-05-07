//
// Strip out OOS Data and View it
//String filename ="/Volumes/Macintosh HD/Users/kimhind/Kim/Work/Companies/Orion/OOS/Data/LPS1_2020";
String filename ="LPS1_2020";
float PipeDiameterMetre=0.32385;

Table OOS_table;
int NoCols=13;
boolean keyFlag=true;
boolean ENPlotFlag=false;
boolean DispEventsBarFlag = true;
boolean DispKeyFlag=true;
boolean DispMSBFlag=true;
boolean CoarseZoomFlag=true;

//int dateColumn = 0;
//int timeColumn = 1;
int KPColumn = 0;
int KPDVLColumn = 1;
int TOPEColumn = 3;
int TOPNColumn = 4;
int pressureColumn =4;
int tideColumn = 5;
int TOPdepthColumn = 5;
int LAdjdepthColumn = 12;
int RAdjdepthColumn = 14;
int MSBLdepthColumn = 16;
int MSBRdepthColumn = 18;

int col_No=0;
int row_No=0;

int canvasX=900;
int canvasY=400;

int scalingX=200;
int scalingY=3;
int totalRows;

float minDepth;
float minKP;
float maxDepth;
float maxKP;

float CalKP;

float WindowMinDepth;
float WindowMaxDepth;
float WindowMinKP;
float WindowMaxKP;
float WindowMinE;
float WindowMaxE;
float WindowMinN;
float WindowMaxN;
float WindowHtDepth;
float WindowWidthKP;
float WindowHtN;
float WindowWidthE;
float WindowShiftValue=2.0;
float WindowScaleUpValue=2.0;
float WinowScaleDownValue=0.5;



void setup()
{
  minDepth=68;
  minKP=0.6;
  maxDepth=85;
  maxKP=2.6;
  WindowMinDepth=73;
  WindowMinKP=1;
  WindowMaxDepth=79;
  WindowMaxKP=1.5;
  WindowHtDepth=6.0;
  WindowWidthKP=0.5;

  size(900, 600);
  OOS_table=loadTable(filename+".csv");
  println("Loaded " + filename+".csv");
  println(OOS_table.getRowCount() + " rows");
  totalRows= OOS_table.getRowCount();
  getTableLimits();
  ENPlotFlag=true;
  WindowHtN=WindowMaxN-WindowMinN;
  WindowWidthE=WindowMaxE-WindowMinE; 
  WindowHtN=0.666 * WindowWidthE;
  WindowMaxKP=WindowMinKP+WindowWidthKP;
  WindowMaxDepth=WindowMinDepth+WindowHtDepth;
  background(100);
  getTableLimits();
  WindowHtDepth=WindowMaxDepth-WindowMinDepth;
  WindowWidthKP=WindowMaxKP-WindowMinKP;
}

void draw()
{
  float mouseKP, mouseDepth;
  if (keyFlag)
  {
    if (ENPlotFlag==true)
    {
      setBlueLine(); //TOP of Pipe Colour
      fill(0, 0, 255);
      text("TOP  ", 020, 580);
      //     WindowMaxDepth=WindowMinDepth+WindowHtDepth;
      PlotEN(TOPEColumn, TOPNColumn, 0, totalRows-1, scalingX, scalingY, 0);
    } else
    {
//    println("Plotting...");
      println("Window KP " + WindowMinKP + ", " + WindowMaxKP + "  WindowMinDepth  " + WindowMinDepth + ", " + WindowMaxDepth);
      setBlueLine(); //TOP of Pipe Colour
      fill(0, 0, 255);
      text("TOP  BOP", 020, 580);
      PlotDepth(KPColumn, TOPdepthColumn, 0, totalRows-1, scalingX, scalingY, 0);
      PlotDepth(KPColumn, TOPdepthColumn, 0, totalRows-1, scalingX, scalingY, PipeDiameterMetre);

      setRedLine(); //Seabed Adj of Pipe Colour
      fill(255, 0, 0);
      text("Adj L", 80, 580);
      PlotDepth(KPColumn, LAdjdepthColumn, 0, totalRows-1, scalingX, scalingY, 0);
      setGreenLine();
      //      stroke(200, 0, 200);
      fill(0, 255, 0);
      text("Adj R", 120, 580);
      PlotDepth(KPColumn, RAdjdepthColumn, 0, totalRows-1, scalingX, scalingY, 0);


      if (DispMSBFlag) //If DispMSBFlag is True then plot the MSBL and MSBR
      {
        setGoldLine(); //MeanSeabedLeft of Pipe Colour
        //fill(200, 100, 0);
        text("SBD L", 160, 580);
        PlotDepth(KPColumn, MSBLdepthColumn, 0, totalRows-1, scalingX, scalingY, 0);
        //stroke(250, 250, 0);
        setCyanLine(); //MeanSeabedRight of Pipe Colour
        //fill(100, 255, 0);
        text("SBD R", 200, 580);
        PlotDepth(KPColumn, MSBRdepthColumn, 0, totalRows-1, scalingX, scalingY, 0);
      }
      if (DispEventsBarFlag) //If DispEventsBarFlag is True then display the Events Bar
      {
        PlotEvents(KPColumn, TOPdepthColumn, LAdjdepthColumn, RAdjdepthColumn, 0, totalRows-1, scalingX, PipeDiameterMetre);
      }
    }
  }
  keyFlag=false;

  if (ENPlotFlag)
  {
    mouseKP=map(mouseX, 0, 900, WindowMinE, WindowMaxE);
    mouseDepth=map(mouseY, 600, 0, WindowMinN, WindowMaxN);
    CalKP = getKP(mouseKP, mouseDepth, KPColumn, TOPEColumn, TOPNColumn);
  } else
  {
    mouseKP=map(mouseX, 0, 900, WindowMinKP, WindowMaxKP);
    mouseDepth=map(mouseY, 0, 600, WindowMinDepth, WindowMaxDepth);
  }
  showKP(mouseKP, mouseDepth, CalKP);


  if (keyPressed)
  {
    keyFlag = ! keyFlag;
    delay(150);

    if (key == 'p' || key == 'P')
    {

      ENPlotFlag = ! ENPlotFlag;
      background(250);
      //getTableLimits();

      if (ENPlotFlag)
      {
        WindowWidthE=WindowMaxE-WindowMinE;
        WindowHtN=0.666 * WindowWidthE;
      } else
      {
        WindowHtDepth=WindowMaxDepth-WindowMinDepth;
        WindowWidthKP=WindowMaxKP-WindowMinKP;
      }

      keyFlag=true;
    }

    if (key == 'a' || key == 'A')
    {
      if (ENPlotFlag)
      {
        WindowMinE-=(WindowWidthE/WindowShiftValue);
      } else 
      {
        WindowMinKP-=(WindowWidthKP/WindowShiftValue);
        WindowMaxKP=WindowMinKP+WindowWidthKP;
      }
    }
    if (key == 'd' || key == 'D')
    {
      if (ENPlotFlag)
      {
        WindowMinE+=(WindowWidthE/WindowShiftValue);
      } else 
      {
        WindowMinKP+=(WindowWidthKP/WindowShiftValue);
        WindowMaxKP=WindowMinKP+WindowWidthKP;
        println(keyFlag);
      }
    }
    if (key == 'w' || key == 'W')
    {
      if (ENPlotFlag)
      {
        WindowMinN+=(WindowHtN/WindowShiftValue);
      } else 
      {
        WindowMinDepth-=(WindowHtDepth/WindowShiftValue);
        WindowMaxDepth=WindowMinDepth+WindowHtDepth;
      }
    }
    if (key == 'x' || key == 'X')
    {

      if (ENPlotFlag)
      {
        WindowMinN-=(WindowHtN/WindowShiftValue);
      } else 
      {
        WindowMinDepth+=(WindowHtDepth/WindowShiftValue);
        WindowMaxDepth=WindowMinDepth+WindowHtDepth;
      }
    }

    if (key == 'q')
    {
      WindowWidthKP*=WinowScaleDownValue;
      if (WindowWidthKP< 0.01)
        WindowWidthKP=0.01;
    }
    if (key == 'Q' )
    {       
      WindowWidthKP*=WindowScaleUpValue;
    }

    if (key == 'e')
    {
      WindowHtDepth*=WinowScaleDownValue;
      if (WindowHtDepth<0.2)
        WindowHtDepth=0.1;
    }
    if (key == 'E' )
    {
      WindowHtDepth*=WindowScaleUpValue;
    } 
    if (key == 'k' || key == 'K')
    {
      DispKeyFlag = ! DispKeyFlag;
    }
    if (key == 'b' || key == 'B')
    {
      DispEventsBarFlag = ! DispEventsBarFlag;
    }
    if (key == 'm' || key == 'M')
    {
      DispMSBFlag = ! DispMSBFlag;
    }
    if (key == 'Z')
    {
      if (CoarseZoomFlag)
      {
        CoarseZoomFlag = ! CoarseZoomFlag;
        WindowShiftValue=2.0;
        WindowScaleUpValue=2.0;
        WinowScaleDownValue=0.5;   
        println("WindowShiftValue, WindowScaleUpValue, WinowScaleDownValue   ", WindowShiftValue, WindowScaleUpValue, WinowScaleDownValue);
      } else
      {
        WindowShiftValue=4.0;
        WindowScaleUpValue=1.2;
        WinowScaleDownValue=0.8; 
        println("WindowShiftValue, WindowScaleUpValue, WinowScaleDownValue   ", WindowShiftValue, WindowScaleUpValue, WinowScaleDownValue);
      }           
      println("CoarseZoomFlag   ", CoarseZoomFlag);
    }
    if (ENPlotFlag)
    {
      WindowHtDepth=0.666 * WindowWidthE;
    }


    WindowMaxE=WindowMinE+WindowWidthE;
    WindowMaxN=WindowMinN+WindowHtN;

    WindowMaxKP=WindowMinKP+WindowWidthKP;
    WindowMaxDepth=WindowMinDepth+WindowHtDepth;
    background(100);

//    println("Window KP " + WindowMinKP + ", " + WindowMaxKP + "  WindowMinDepth  " + WindowMinDepth + ", " + WindowMaxDepth);
//    println("keyFlag, ENPlotFlag   ", keyFlag, ENPlotFlag);
//    println("WindowWidthKP, WindowHtDepth   ", WindowWidthKP, WindowHtDepth);
  }
}

void setRedLine()
{
  stroke(255, 0, 0);
}

void setGreenLine()
{
  stroke(0, 255, 0);
}
void setBlueLine()
{
  stroke(0, 0, 255);
}
void setYellowLine()
{
  stroke(255, 255, 0);
  fill(255, 255, 0);
}
void setGoldLine()
{
  stroke(255, 215, 0);
  fill(255, 215, 0);
}
void setMagentaLine()
{
  stroke(255, 255, 0);
  fill(255, 255, 0);
}
void setOrangeLine()
{
  stroke(255, 165, 0);
  fill(255, 165, 0);
}
void setTurqoiseLine()
{
  stroke(64, 224, 208);
}
void setCyanLine()
{
  stroke(0, 255, 255);
  fill(0, 255, 255);
}
void PlotEN(int EColumn, int NColumn, int rowStart, int rowEnd, int scalingX, int scalingY, float DiamPipe)
{
  int i=0;


  for (i=rowStart; i<rowEnd; i++)
  {
    float StartSegmentX= OOS_table.getFloat(i, EColumn);
    float StartSegmentY= DiamPipe + OOS_table.getFloat(i, NColumn);
    float EndSegmentX= OOS_table.getFloat(i+1, EColumn);
    float EndSegmentY= DiamPipe + OOS_table.getFloat(i+1, NColumn);

    float ScaledStartX, ScaledStartY, ScaledEndX, ScaledEndY;

    ScaledStartX=map(StartSegmentX, WindowMinE, WindowMaxE, 0, width);
    ScaledStartY=map(StartSegmentY, WindowMinN, WindowMaxN, height, 0 );   

    ScaledEndX=map(EndSegmentX, WindowMinE, WindowMaxE, 0, width);
    ScaledEndY=map(EndSegmentY, WindowMinN, WindowMaxN, height, 0 ); 

    line( ScaledStartX, ScaledStartY, ScaledEndX, ScaledEndY);
  }
}

void PlotDepth(int KPColumn, int DepthColumn, int rowStart, int rowEnd, int scalingX, int scalingY, float DiamPipe)
{
  int i=0;
  float depthDifference;
  float KPDifference;

  for (i=rowStart; i<rowEnd; i++)
  {
    float StartSegmentX= OOS_table.getFloat(i, KPColumn);
    float StartSegmentY= DiamPipe + OOS_table.getFloat(i, DepthColumn);
    float EndSegmentX= OOS_table.getFloat(i+1, KPColumn);
    float EndSegmentY= DiamPipe + OOS_table.getFloat(i+1, DepthColumn);

    float ScaledStartX, ScaledStartY, ScaledEndX, ScaledEndY;

    ScaledStartX=map(StartSegmentX, WindowMinKP, WindowMaxKP, 0, width);
    ScaledStartY=map(StartSegmentY, WindowMaxDepth, WindowMinDepth, height, 0);   

    ScaledEndX=map(EndSegmentX, WindowMinKP, WindowMaxKP, 0, 900);
    ScaledEndY=map(EndSegmentY, WindowMaxDepth, WindowMinDepth, 600, 0); 

    line( ScaledStartX, ScaledStartY, ScaledEndX, ScaledEndY);
  }
}
//Plot an events bar at the top of the screen
void PlotEvents(int KPColumn, int TOPColumn, int LAdjdepthColumn, int RAdjdepthColumn, int rowStart, int rowEnd, int scalingX, float pipeDiam)
{
  int i=0;
  float depthTOP;
  float depthSBL;
  float depthSBR;
  strokeWeight(4);


  for (i=rowStart; i<rowEnd; i++)
  {
    float StartSegmentX = OOS_table.getFloat(i, KPColumn);
    depthTOP = OOS_table.getFloat(i, TOPColumn);
    depthSBL = OOS_table.getFloat(i, LAdjdepthColumn);
    depthSBR = OOS_table.getFloat(i, RAdjdepthColumn);
    float EndSegmentX= OOS_table.getFloat(i+1, KPColumn);
    if (depthTOP+pipeDiam<(depthSBL+depthSBR)/2.0) //FREESPAN
    {
      setRedLine();
    } else if (depthTOP>(depthSBL+depthSBR)/2.0) //BURIED
    {
      setBlueLine();
    } else
    {
      setGreenLine(); //NORMAL
    }
    float ScaledStartX, ScaledEndX;

    ScaledStartX=map(StartSegmentX, WindowMinKP, WindowMaxKP, 0, width);

    ScaledEndX=map(EndSegmentX, WindowMinKP, WindowMaxKP, 0, 900);

    line(ScaledStartX, 597, ScaledEndX, 597);
  }
  strokeWeight(1);
}
void showKP(float mouseKP, float mouseDepth, float CalcKP)
{
  noStroke();
  fill(100);
  rect(700, 535, 200, 60);
  fill(0);
  textSize(14);
  stroke(0);
  noStroke(); 

  if (DispKeyFlag)
  {
    if (DispEventsBarFlag)
    {    // Key for Events Bar Colour
      text("Events Key ", 700, 460);
      text("Green: On Seabed", 700, 480);
      text("Red   : Freespan", 700, 500);
      text("Blue  : Buried", 700, 520);
    }
    // Key for Button Presses
    text("Key for Button Presses", 700, 60);
    text("p/P: Switch Display", 700, 80);
    text("a/A: Left", 700, 100);
    text("d/D: Right", 700, 120);
    text("w/W: Up", 700, 140);
    text("x/X: Down", 700, 160);
    text("Q  : Stack KP", 700, 180);
    text("q  : Stretch KP", 700, 200);
    text("E  : Stack Depth", 700, 220);
    text("e  : Stretch Depth", 700, 240);
    text("z  : Coarse Zoom Toggle", 700, 260);
    text("k/K: Key On / Off", 700, 280);
    text("b/B: Events Bar On / Off", 700, 300);
    text("m/M: SBL & SBR On / Off", 700, 320);
  }
  //  Numerical Display
  if (ENPlotFlag) //Plan View Numerical Display
  {
    text("KP= ", 700, 560); 
    text(CalcKP, 780, 560);
    text("Easting= ", 700, 575);
    text("Northing= ", 700, 590);
  } else  //LP Numerical Display
  {
    text("Coarse Flag= ", 700, 560); 
    text(int(CoarseZoomFlag), 820, 560);
    text("KP= ", 700, 575);
    text("Depth= ", 700, 590);
  }
  text(mouseKP, 780, 575);
  text(mouseDepth, 780, 590);
}
void getTableLimits()
{
  int k=0;

  WindowMinKP= OOS_table.getFloat(k, KPColumn);
  WindowMaxKP= WindowMinKP;
  WindowMinE= OOS_table.getFloat(k, TOPEColumn);
  WindowMaxE= WindowMinE;
  WindowMinN= OOS_table.getFloat(k, TOPNColumn);
  WindowMaxN= WindowMinN;
  WindowMinDepth= OOS_table.getFloat(k, TOPdepthColumn);
  WindowMaxDepth= WindowMinKP;  


  for (k=0; k<totalRows; k++)
  {
    if (WindowMinKP> OOS_table.getFloat(k, KPColumn))
      WindowMinKP= OOS_table.getFloat(k, KPColumn);

    if (WindowMaxKP< OOS_table.getFloat(k, KPColumn))
      WindowMaxKP= OOS_table.getFloat(k, KPColumn);

    if (WindowMinE> OOS_table.getFloat(k, TOPEColumn))
      WindowMinE= OOS_table.getFloat(k, TOPEColumn);

    if (WindowMaxE< OOS_table.getFloat(k, TOPEColumn))
      WindowMaxE= OOS_table.getFloat(k, TOPEColumn);

    if (WindowMinN> OOS_table.getFloat(k, TOPNColumn))
      WindowMinN= OOS_table.getFloat(k, TOPNColumn);

    if (WindowMaxN< OOS_table.getFloat(k, TOPNColumn))
      WindowMaxN= OOS_table.getFloat(k, TOPNColumn);

    if (WindowMinDepth> OOS_table.getFloat(k, TOPdepthColumn))
      WindowMinDepth= OOS_table.getFloat(k, TOPdepthColumn);

    if (WindowMaxDepth< OOS_table.getFloat(k, TOPdepthColumn))
      WindowMaxDepth= OOS_table.getFloat(k, TOPdepthColumn);
  }
//  println("Min Max, KP, Depth ", WindowMinKP, WindowMaxKP, WindowMinDepth, WindowMaxDepth);
//  println("Min Max, E, N ", WindowMinE, WindowMaxE, WindowMinN, WindowMaxN);
}
float getKP(float E, float N, int KPColumn, int TOPEColumn, int TOPNColumn)
{
  float diffE, diffN, tempMinDist, PresentDist, tempKP;
  tempKP= OOS_table.getFloat(0, KPColumn);
  diffE = E-OOS_table.getFloat(0, TOPEColumn);
  diffN = N-OOS_table.getFloat(0, TOPNColumn);
  tempMinDist=drp(diffE, diffN);
  for (int i=0; i<totalRows; i++)
  {
    diffE = E-OOS_table.getFloat(i, TOPEColumn);
    diffN = N-OOS_table.getFloat(i, TOPNColumn);
    PresentDist=drp(diffE, diffN);
    if (PresentDist<tempMinDist)
    {
      tempMinDist=PresentDist;
      tempKP=OOS_table.getFloat(i, KPColumn);
    }
  }
  // println("Send CalcKP", tempKP);
  return(tempKP);
}

float drp(float DE, float DN)
{
  return(sqrt(DE * DE + DN * DN));
}