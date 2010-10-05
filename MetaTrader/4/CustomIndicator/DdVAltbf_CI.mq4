//+------------------------------------------------------------------+
//|                                                  DdVAltbf_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red

double buffer[];

int init() {

   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 234);
   SetIndexBuffer(0, buffer);
   ArrayInitialize(buffer, EMPTY_VALUE);

   return(0);
}

int start() {
   int   counted_bars=IndicatorCounted();

   for (int i=(Bars-1)-counted_bars; i>=0; i--) {
      if (
            (dxMACD(i) && dxSto(i) && dxMA(i))
         && (!dxMACD(i+1) || !dxSto(i+1) || !dxMA(i+1))
         ) {
         buffer[i] = High[i] + ((High[i]-Low[i])/2);
      }
   }

   return(0);
}

bool dxMACD(int idx) {
   double slow, quic;

   slow  = iCustom(NULL, 0, "MACD", 12, 26, 9, 1, idx);
   quic  = iCustom(NULL, 0, "MACD", 12, 26, 9, 0, idx);

   return (slow > quic);
}

bool dxSto(int idx) {
   double slow, quic;
   
   slow  = iCustom(NULL, 0, "slowstochastics", 14, 5, 5, 1, idx);
   quic  = iCustom(NULL, 0, "slowstochastics", 14, 5, 5, 0, idx);

   return (slow > quic);
}

bool dxMA(int idx) {
   double up;

   up = iCustom(NULL, 0, "MA in Color", 21, 1, 1, idx);

   return (up == EMPTY_VALUE);
}

