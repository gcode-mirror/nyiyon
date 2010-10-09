//+------------------------------------------------------------------+
//|                                              HighLow_Line_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window

#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 LightSeaGreen
#property indicator_color3 LightSeaGreen

extern int ExtMAPeriod        = 100;
extern int ExtHighLowPeriod   = 26;

double bufferMA[];
double bufferHigh[];
double bufferLow[];

//+------------------------------------------------------------------+
int init() {

   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);

   SetIndexBuffer(0, bufferMA);
   SetIndexBuffer(1, bufferHigh);
   SetIndexBuffer(2, bufferLow);

   ArrayInitialize(bufferMA, EMPTY_VALUE);
   ArrayInitialize(bufferHigh, EMPTY_VALUE);
   ArrayInitialize(bufferLow, EMPTY_VALUE);
   
	return(0);
}

//+------------------------------------------------------------------+
int start() {
   int limit = MathMin(Bars - IndicatorCounted(), Bars - MathMax(ExtMAPeriod, ExtHighLowPeriod));

   for (int i=0; i<limit; i++) {
      bufferMA[i]    = iMA(NULL, 0, ExtMAPeriod, 0, MODE_EMA, PRICE_CLOSE, i);
      bufferHigh[i]  = High[iHighest(NULL, 0, MODE_HIGH, ExtHighLowPeriod, i)];
      bufferLow[i]   = Low[iLowest(NULL, 0, MODE_LOW, ExtHighLowPeriod, i)];
   }

   return(0);
}

//+------------------------------------------------------------------+

