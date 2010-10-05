//+------------------------------------------------------------------+
//|                                       Output_Distribution_SC.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

extern string  ExtFileName    = "distribution.csv";
extern int     ExtPeriod      = 20;
extern double  ExtDeviation1  = 1.0;  
extern double  ExtDeviation2  = 2.0;  

int fp;

//+------------------------------------------------------------------+
int init() {

   fp = FileOpen(ExtFileName, FILE_CSV|FILE_WRITE, ",");

   if (fp < 1) {
      Print("Cant open file:", ExtFileName, ", reason:", GetLastError());
      return (-1);
   }

   return(0);
}

//+------------------------------------------------------------------+
int start() {
   int limit = MathMin(Bars-ExtPeriod, Bars-IndicatorCounted());
   double sp2, sm2;

   FileWrite(fp, "date", "high", "close", "low", "s+2", "s-2");
   for (int i=0; i<limit; i++) {
      sp2 = iCustom(NULL, 0, "BolingerBands_CI", ExtPeriod, ExtDeviation1, ExtDeviation2, 0, i);
      sm2 = iCustom(NULL, 0, "BolingerBands_CI", ExtPeriod, ExtDeviation1, ExtDeviation2, 4, i);
      FileWrite(fp, TimeToStr(Time[i]), High[i], Close[i], Low[i], sp2, sm2);
   }

   return(0);
}

//+------------------------------------------------------------------+
int deinit() {
   if (fp >= 1) {
      FileClose(fp);
   }

   return(0);
}

