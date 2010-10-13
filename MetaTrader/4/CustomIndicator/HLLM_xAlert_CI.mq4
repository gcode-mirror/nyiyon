//+------------------------------------------------------------------+
//|                                               HLLM_xAlert_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window

#property indicator_buffers 1
#property indicator_color1 Red

extern int ExtMAPeriod        = 100;
extern int ExtHighLowPeriod   = 26;

double buffer[];

//+------------------------------------------------------------------+
int init() {

   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, 234);

   SetIndexBuffer(0, buffer);

	return(0);
}

//+------------------------------------------------------------------+
int deinit() {

   ArrayInitialize(buffer, EMPTY_VALUE);

    return(0);
}

//+------------------------------------------------------------------+
int start() {
   int limit = MathMin(Bars - IndicatorCounted(), Bars - MathMax(ExtMAPeriod, ExtHighLowPeriod));
   static datetime lastTime;

   for (int i=0; i<limit; i++) {
      if (crossOver(i)) {
         buffer[i] = Close[i];

         // when real time
         if (limit == 1 && lastTime != Time[0]) {
            lastTime = Time[0];
            Alert("HighLowLine+MA is crossed");
         }
      } else {
         buffer[i] = EMPTY_VALUE;
         lastTime = EMPTY;
      }

   }

   return(0);
}

//+------------------------------------------------------------------+
bool crossOver(int i) {
   double currentMA, currentHigh, currentLow;
   double lastMA, lastHigh, lastLow;

   currentMA   = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 0, i);
   currentHigh = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 1, i);
   currentLow  = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 2, i);

   lastMA   = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 0, i+1);
   lastHigh = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 1, i+1);
   lastLow  = iCustom(NULL, 0, "HighLowLine+MA_CI", ExtMAPeriod, ExtHighLowPeriod, 2, i+1);

   if (
         currentMA > currentHigh
      && lastMA <= lastHigh ) {
      return (true);
   }

   if (
         currentMA < currentLow
      && lastMA >= lastLow ) {
      return (true);
   }

   return (false);
}

