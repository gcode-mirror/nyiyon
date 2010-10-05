//+------------------------------------------------------------------+
//|                                             BolingerBands_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 LightPink
#property indicator_color2 LemonChiffon
#property indicator_color3 LightCyan
#property indicator_color4 LemonChiffon
#property indicator_color5 LightPink

extern int     ExtPeriod      = 20;
extern double  ExtDeviation1  = 1.0;
extern double  ExtDeviation2  = 2.0;

double bufferUpper2[];
double bufferUpper1[];
double bufferCenter[];
double bufferLower1[];
double bufferLower2[];

//+------------------------------------------------------------------+
int init() {

   SetIndexBuffer(0, bufferUpper2);
   SetIndexBuffer(1, bufferUpper1);
   SetIndexBuffer(2, bufferCenter);
   SetIndexBuffer(3, bufferLower1);
   SetIndexBuffer(4, bufferLower2);

   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexStyle(4, DRAW_LINE);

   SetIndexDrawBegin(0, ExtPeriod);
   SetIndexDrawBegin(1, ExtPeriod);
   SetIndexDrawBegin(2, ExtPeriod);
   SetIndexDrawBegin(3, ExtPeriod);
   SetIndexDrawBegin(4, ExtPeriod);

   return(0);
}

//+------------------------------------------------------------------+
int start() {
   int      limit = MathMin((Bars-ExtPeriod), (Bars - IndicatorCounted()));
   double   stdv, s1, s2;

   for (int i=0; i<limit; i++) {
      bufferCenter[i] = average(i, ExtPeriod);

      stdv  = stdev(i, ExtPeriod);
      s1    = stdv * ExtDeviation1;
      s2    = stdv * ExtDeviation2;

      bufferUpper2[i] = bufferCenter[i] + s2;
      bufferUpper1[i] = bufferCenter[i] + s1;
      bufferLower1[i] = bufferCenter[i] - s1;
      bufferLower2[i] = bufferCenter[i] - s2;
   }

   return(0);
}

//+------------------------------------------------------------------+
double average(int start, int period) {
   double sum = 0.0;

   for (int i=start; i<start+period; i++) {
      sum += Close[i];
   }

   return (sum / period);
}

double stdev(int start, int period) {
   double sum = 0.0, average = bufferCenter[start];

   for (int i=start; i<start+period; i++) {
      sum += MathPow(Close[i] - average, 2);
   }

   return (MathSqrt(sum / period));
}