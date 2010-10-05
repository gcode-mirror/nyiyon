//+------------------------------------------------------------------+
//|                                            Output_Morning_sc.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

extern string  ExtFileName    = "morning.csv";
extern int     ExtTargetTime  = 9;

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

   int limit   = Bars;
   int diffH   = diffTime() * 3600;
   int i;

   FileWrite(fp, "date", "date[jp]", ExtTargetTime);

   for (i=1; i<limit; i++) {
      if (TimeHour(Time[i]+diffH) == ExtTargetTime) {
         FileWrite(fp, TimeToStr(Time[i]), TimeToStr(Time[i]+diffH), Close[i] - Open[i]);
      }
   }

   return(0);
}

//+------------------------------------------------------------------+
int deinit() {
   if (fp >= 1) {
      FileClose(fp);
   }
}

//+------------------------------------------------------------------+
int diffTime() {
   return ((TimeLocal()-TimeCurrent())/60/60);
}