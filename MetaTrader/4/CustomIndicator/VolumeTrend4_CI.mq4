//+------------------------------------------------------------------+
//|                                              VolumeTrend4_CI.mq4 |
//|                                      Copyright © 2011, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_separate_window

#property indicator_buffers 8

#property indicator_color1 0x606060
#property indicator_color2 0x606060
#property indicator_color3 Lime
#property indicator_color4 Red
#property indicator_color5 Gold
#property indicator_color6 Gold
#property indicator_color7 White
#property indicator_color8 White

#property indicator_width1 2
#property indicator_width2 2

#property indicator_style7 STYLE_DOT
#property indicator_style8 STYLE_DOT

#property indicator_level1 200
#property indicator_level2 -200
#property indicator_levelcolor 0x828282
#property indicator_levelstyle STYLE_DOT

double upEstimate[];
double downEstimate[];
double upVolume[];
double downVolume[];
double upFlatVolume[];
double downFlatVolume[];
double upLine[];
double downLine[];

extern int volumePerTime = 40;
//+------------------------------------------------------------------+
int init() {

    SetIndexStyle(0, DRAW_HISTOGRAM);
    SetIndexStyle(1, DRAW_HISTOGRAM);
    SetIndexStyle(2, DRAW_HISTOGRAM);
    SetIndexStyle(3, DRAW_HISTOGRAM);
    SetIndexStyle(4, DRAW_HISTOGRAM);
    SetIndexStyle(5, DRAW_HISTOGRAM);
    SetIndexStyle(6, DRAW_LINE);
    SetIndexStyle(7, DRAW_LINE);

    SetIndexBuffer(0, upEstimate);
    SetIndexBuffer(1, downEstimate);
    SetIndexBuffer(2, upVolume);
    SetIndexBuffer(3, downVolume);
    SetIndexBuffer(4, upFlatVolume);
    SetIndexBuffer(5, downFlatVolume);
    SetIndexBuffer(6, upLine);
    SetIndexBuffer(7, downLine);

    SetIndexLabel(0, "Estimate Volume");
    for (int i=1; i<8; i++) {
        SetIndexLabel(i, NULL);
    }

    SetLevelValue(0, Period()*volumePerTime);
    SetLevelValue(1, Period()*(-volumePerTime));

    IndicatorDigits(0);
    IndicatorShortName("VolumeTrend4_CI");

    return(0);
}

//+------------------------------------------------------------------+
int start() {
    int limit = MathMin(Bars -1, Bars - IndicatorCounted()) -1;

    for (int i=limit; i>=0; i--) {

        if (Close[i+1] < Close[i]) {
            upVolume[i]         = Volume[i];
            downVolume[i]       = EMPTY_VALUE;
            upFlatVolume[i]     = EMPTY_VALUE;
            downFlatVolume[i]   = EMPTY_VALUE;
        } else if (Close[i+1] == Close[i] ) {
            downVolume[i]       = EMPTY_VALUE;
            upVolume[i]         = EMPTY_VALUE;
            if (upVolume[i+1] != EMPTY_VALUE || upFlatVolume[i+1] != EMPTY_VALUE) {
                upFlatVolume[i]     = Volume[i];
                downFlatVolume[i]   = EMPTY_VALUE;
            }
            if (downVolume[i+1] != EMPTY_VALUE || downFlatVolume[i+1] != EMPTY_VALUE) {
                downFlatVolume[i]   = Volume[i]*(-1);
                upFlatVolume[i]     = EMPTY_VALUE;
            }
        } else if (Close[i+1] > Close[i]) {
            downVolume[i]       = Volume[i]*(-1);
            upVolume[i]         = EMPTY_VALUE;
            upFlatVolume[i]     = EMPTY_VALUE;
            downFlatVolume[i]   = EMPTY_VALUE;
        }

        upLine[i]   = average(i, 14) * 2;
        downLine[i] = upLine[i] * (-1);

        double pastRatio;
        if (i>0) {
            upEstimate[i]   = EMPTY_VALUE;
            downEstimate[i] = EMPTY_VALUE;
        } else if (i==0) {
            pastRatio = (TimeCurrent() - Time[0]);
            pastRatio /= (Period() * 60);

            if (pastRatio > 0.05) {
                upEstimate[i]   = Volume[i] / pastRatio;
                downEstimate[i] = upEstimate[i] * (-1);
            }
        }
    }

    return(0);
}

//+------------------------------------------------------------------+
double average(int start, int period) {
   double sum = 0.0;

   for (int i=start; i<start+period; i++) {
      sum += Volume[i];
   }

   return (sum / period);
}

