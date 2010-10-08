//+------------------------------------------------------------------+
//|                                              PerfectOrder_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

#property indicator_maximum 2.1
#property indicator_minimum -0.1


extern int ExtMAMode    = MODE_EMA;

double buffer[];

//+------------------------------------------------------------------+
int init() {

   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, buffer);

	return(0);
}

//+------------------------------------------------------------------+
int start() {
   int   limit = Bars - IndicatorCounted();

   for (int i=limit-1; 0<=i; i--) {
      buffer[i] = order(i);
   }

   return(0);
}

//+------------------------------------------------------------------+
int order(int i) {
   int result = 0;

   double
      ma1 = iCustom(NULL, 0, "FiveMAs_CI", ExtMAMode, 0, i),
      ma2 = iCustom(NULL, 0, "FiveMAs_CI", ExtMAMode, 1, i),
      ma3 = iCustom(NULL, 0, "FiveMAs_CI", ExtMAMode, 2, i),
      ma4 = iCustom(NULL, 0, "FiveMAs_CI", ExtMAMode, 3, i),
      ma5 = iCustom(NULL, 0, "FiveMAs_CI", ExtMAMode, 4, i),
      adx = iCustom(NULL, 0, "adx", 0, i);

   if (ma1 > ma2
    && ma2 > ma3
    && ma3 > ma4
    && ma4 > ma5) {
      result += 1;
   }
   if (adx >= 20.0) {
      result +=1;
   }

   return (result);
}

