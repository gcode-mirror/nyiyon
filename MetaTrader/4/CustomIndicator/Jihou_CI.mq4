//+------------------------------------------------------------------+
//|                                                     Jihou_CI.mq4 |
//|                                      Copyright © 2011, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window

#define OBJECT_NOT_FOUND -1
#define DAMMY_PRICE 0
#define MAIN_WINDOW 0

#define CURRENT_SYMBOL NULL
#define CURRENT_TIME 0

#define LINE_NAME "Jihou_CI."

datetime timeStep;
int upperTf;
datetime upperTimeStep;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
    timeStep = Period() * 60;

    switch (Period()) {
        case PERIOD_M5:
            upperTf = PERIOD_M30;
            break;
        case PERIOD_M30:
            upperTf = PERIOD_H4;
            break;
        case PERIOD_H1:
            upperTf = PERIOD_H4;
            break;
        case PERIOD_H4:
            upperTf = PERIOD_D1;
            break;
        case PERIOD_D1:
            upperTf = PERIOD_W1;
            break;
        default:
            upperTf = EMPTY;
    }

    if (upperTf != EMPTY) {
        upperTimeStep = upperTf * 60;
    }

    return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
    ObjectDelete(LINE_NAME+"next");
    ObjectDelete(LINE_NAME+"last");

    return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {

    // sounds Jihou @25m & @55m
    soundsJihou();

    // vline drew at boundary of timeframe
    if (IndicatorCounted() != Bars) {
        setBoundaryLine();
    }
}

//+------------------------------------------------------------------+
//| Jihou.wav from http://www.hadakadenkyu.flnet.org/files.htm
//+------------------------------------------------------------------+
void soundsJihou() {
    static datetime lastSoundsTime = EMPTY;

    // this func only work M5 period
    if (Period() != PERIOD_M5) return(0);

    // if not sounds yet current bar
    if (lastSoundsTime != Time[0]) {// sounds only once in one bar
        if ((Minute() == 25)        // sounds when 25 minutes in every hour
         || (Minute() == 55)) {     // sounds when 55 minutes in every hour

            // sounds jihou
            PlaySound("Jihou.wav");

            // replace last time
            lastSoundsTime = Time[0];
        }
    }
     
    return(0);
}

//+------------------------------------------------------------------+
void setBoundaryLine() {

    // this func only work M5/M30/H1/H4/D1 periods
    if (upperTf == EMPTY) return (0);


    // set line only once in one bar
    static datetime lastSetTime = EMPTY;

    if (lastSetTime == Time[0]) return(0);

    // set vline @last close time of upper TimeFrame 
    datetime upperTime = iTime(CURRENT_SYMBOL, upperTf, CURRENT_TIME);

    for (int i=0; i<10; i++) {   // max need range is H4/M30=8? (M30/M5=6 H4/H1=4 D1/H4=6 W1/D1=7)
        if (Time[i] < upperTime) {
            // drow line
            drowLine(Time[i], LINE_NAME + "last");
            break;
        }
    }

    // set vline @current close time of upper TimeFrame 
    datetime upperNextTime = upperTime + upperTimeStep;
    datetime nextTime = Time[0] + timeStep;

    if (nextTime == upperNextTime) {    // TODO:not work D1
        // drow next line
        drowLine(Time[0], LINE_NAME + "next");
    }


    // replace last time
    lastSetTime = Time[0];
}

void drowLine(datetime x, string name) {

    // search vline(if not exist yet then create and set view style)
    if (ObjectFind(name) == OBJECT_NOT_FOUND) {
        ObjectCreate(name, OBJ_VLINE, MAIN_WINDOW, x, DAMMY_PRICE); // vline not use price data
        ObjectSet(name, OBJPROP_COLOR, SaddleBrown);
        ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
        ObjectSet(name, OBJPROP_BACK, true);
    }

    // move vline
    ObjectSet(name, OBJPROP_TIME1, x);
}

