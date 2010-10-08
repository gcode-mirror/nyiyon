//+------------------------------------------------------------------+
//|                                                   FiveMAs_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 C'255,255,255'
#property indicator_color2 C'200,200,200'
#property indicator_color3 C'150,150,150'
#property indicator_color4 C'100,100,100'
#property indicator_color5 C' 50, 50, 50'

extern int  ExtMAMode      = MODE_EMA;
extern int  ExtMA1Period   = 10;
extern int  ExtMA2Period   = 20;
extern int  ExtMA3Period   = 50;
extern int  ExtMA4Period   = 100;
extern int  ExtMA5Period   = 200;

double bufferMA1[];
double bufferMA2[];
double bufferMA3[];
double bufferMA4[];
double bufferMA5[];

//+------------------------------------------------------------------+
int init() {
   if (
         ExtMA1Period > ExtMA2Period
      || ExtMA2Period > ExtMA3Period
      || ExtMA3Period > ExtMA4Period
      || ExtMA4Period > ExtMA5Period) {
      return (-1);
   }

   SetIndexBuffer(0, bufferMA1);
   SetIndexBuffer(1, bufferMA2);
   SetIndexBuffer(2, bufferMA3);
   SetIndexBuffer(3, bufferMA4);
   SetIndexBuffer(4, bufferMA5);

   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE);
   SetIndexStyle(4, DRAW_LINE);

   SetIndexDrawBegin(0, ExtMA1Period);
   SetIndexDrawBegin(1, ExtMA2Period);
   SetIndexDrawBegin(2, ExtMA3Period);
   SetIndexDrawBegin(3, ExtMA4Period);
   SetIndexDrawBegin(4, ExtMA5Period);

   ArrayInitialize(bufferMA1, EMPTY_VALUE);
   ArrayInitialize(bufferMA2, EMPTY_VALUE);
   ArrayInitialize(bufferMA3, EMPTY_VALUE);
   ArrayInitialize(bufferMA4, EMPTY_VALUE);
   ArrayInitialize(bufferMA5, EMPTY_VALUE);

   return(0);
}

//+------------------------------------------------------------------+
int start() {
   int   limit = MathMin(Bars - IndicatorCounted(), Bars - ExtMA5Period);

   for (int i=limit-1; 0<=i; i--) {
      bufferMA1[i] = iMA(NULL, 0, ExtMA1Period, 0, ExtMAMode, PRICE_CLOSE, i);
      bufferMA2[i] = iMA(NULL, 0, ExtMA2Period, 0, ExtMAMode, PRICE_CLOSE, i);
      bufferMA3[i] = iMA(NULL, 0, ExtMA3Period, 0, ExtMAMode, PRICE_CLOSE, i);
      bufferMA4[i] = iMA(NULL, 0, ExtMA4Period, 0, ExtMAMode, PRICE_CLOSE, i);
      bufferMA5[i] = iMA(NULL, 0, ExtMA5Period, 0, ExtMAMode, PRICE_CLOSE, i);
   }

   return(0);
}

//+------------------------------------------------------------------+

