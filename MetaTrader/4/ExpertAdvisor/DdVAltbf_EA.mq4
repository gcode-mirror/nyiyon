//+------------------------------------------------------------------+
//|                                                  DdVAltbf_EA.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

extern int ExtMagnification = 20;

double minimumMargin;
//+------------------------------------------------------------------+
int init() {

   minimumMargin = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;

   return(0);
}

//+------------------------------------------------------------------+
int deinit() {

   return(0);
}

//+------------------------------------------------------------------+
int start() {

   double signal;

   if (havePosition()) {
      // do nothing
   } else {
      signal = iCustom(NULL, 0, "DdVAltbf_CI", 0, 0);
      if (signal != EMPTY_VALUE) {
         sell(ExtMagnification);
      }
   }

   return(0);
}

//+------------------------------------------------------------------+
bool havePosition() {
   int total = OrdersTotal();
   for (int i=0; i<total; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         return (true);
      }
   }

   return (false);
}

void sell(int mag) {
   int ticket =
   OrderSend(Symbol(), OP_SELL, 0.1, Bid, 3, Ask+minimumMargin*mag, Bid-minimumMargin, NULL, 0, 0, Red);
}

