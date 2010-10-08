//+------------------------------------------------------------------+
//|                                              PerfectOrder_EA.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#define ORDER_PERFECT 2.0

//+------------------------------------------------------------------+
int start() {

   double signal = iCustom(NULL, 0, "PerfectOrder_CI", 0, 1);

   if (signal == ORDER_PERFECT) {
      if (!havePosition()) {
         buy();
      }
   } else {
      if (havePosition()) {
         close();
      }
   }

   return(0);
}
//+------------------------------------------------------------------+
void buy() {
   int ticket =
   OrderSend(Symbol(), OP_BUY, 0.1, Ask, 3, NULL, NULL, NULL, 0, 0, Blue);
}

bool havePosition() {
   int total = OrdersTotal();
   for (int i=0; i<total; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         return (true);
      }
   }

   return (false);
}

void close() {
   int total = OrdersTotal();

   for (int i=0; i<total; i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderType() == OP_BUY) {
            OrderClose(OrderTicket(), 0.1, Bid, 3, Blue);
         }
      }
   }
}

