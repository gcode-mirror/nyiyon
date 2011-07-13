//+------------------------------------------------------------------+
//|                                                 3wariLine_CI.mq4 |
//|                                 Copyright © 2010-2011, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010-2011, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window

#define CI_NAME   "3wariLine_CI"
#define BASE_LINE "3wariLine_CI.base"
#define PEAK_LINE "3wariLine_CI.peak"

#define ENTRY_LINE  "3wariLine_CI.entry"
#define EXIT_LINE   "3wariLine_CI.exit"
#define ALL_SUFIX   ".allreturn"
#define HALF_SUFIX  ".halfreturn"

extern bool all     = true;
extern bool half    = true;
extern color entry_color    = DarkOliveGreen;
extern color exit_color     = SaddleBrown;
extern int entry_style      = STYLE_DASHDOT;
extern int exit_style       = STYLE_DASHDOT;
extern bool background      = true;
//+------------------------------------------------------------------+
int init() {

    return(0);
}

//+------------------------------------------------------------------+
int deinit() {

    ObjectDelete(BASE_LINE);
    ObjectDelete(PEAK_LINE);
    ObjectDelete(ENTRY_LINE+ALL_SUFIX);
    ObjectDelete(EXIT_LINE+ALL_SUFIX);
    ObjectDelete(ENTRY_LINE+HALF_SUFIX);
    ObjectDelete(EXIT_LINE+HALF_SUFIX);

    return(0);
}

//+------------------------------------------------------------------+
int start() {

    int basePoint = getBasePoint();
    int peakPoint = getPeakPoint();

    if (basePoint == EMPTY || peakPoint == EMPTY) {
        Print(CI_NAME, ":error", ":point not found", ",base=", basePoint, ",peak=", peakPoint);
        return(-1);
    }

    double baseValue = Close[basePoint];
    double peakValue = Close[peakPoint];
    double width = baseValue-peakValue;
    double entry, exit;

    // calc +30%line by all return
    width   = baseValue - peakValue;
    entry   = baseValue + (width * 0.3);
    exit    = entry     + (width * 0.6);

    setSignalLine(entry, exit, ALL_SUFIX);

    // calc +30%line by all half return
    width   = width / 2;
    entry   = baseValue - width + (width * 0.3);
    exit    = entry + (width * 0.6);

    setSignalLine(entry, exit, HALF_SUFIX);

    return(0);
}

//+------------------------------------------------------------------+
int getBasePoint() {

   if (ObjectFind(BASE_LINE) == -1) {
      ObjectCreate(BASE_LINE, OBJ_VLINE, 0, Time[10], 0);
      ObjectSet(BASE_LINE, OBJPROP_COLOR, entry_color);
      ObjectSet(BASE_LINE, OBJPROP_BACK, background);
   }

   if (ObjectType(BASE_LINE) != OBJ_VLINE) {
      return (EMPTY);
   }

   return (iBarShift(NULL, 0, ObjectGet(BASE_LINE, OBJPROP_TIME1), true));
}

int getPeakPoint() {

   if (ObjectFind(PEAK_LINE) == -1) {
      ObjectCreate(PEAK_LINE, OBJ_VLINE, 0, Time[5], 0);
      ObjectSet(PEAK_LINE, OBJPROP_COLOR, exit_color);
      ObjectSet(PEAK_LINE, OBJPROP_BACK, background);
   }

   if (ObjectType(PEAK_LINE) != OBJ_VLINE) {
      return (EMPTY);
   }

   return (iBarShift(NULL, 0, ObjectGet(PEAK_LINE, OBJPROP_TIME1), true));
}

void setSignalLine(double entry, double exit, string sufix) {
   if (ObjectFind(ENTRY_LINE+sufix) != -1 && ObjectType(ENTRY_LINE+sufix) != OBJ_HLINE) {
      Print(CI_NAME, ":error", ":entry line cant set");
      return(-1);
   }

   if (ObjectFind(EXIT_LINE+sufix) != -1 && ObjectType(EXIT_LINE+sufix) != OBJ_HLINE) {
      Print(CI_NAME, ":error", ":exit line cant set");
      return(-1);
   }

   if (ObjectFind(ENTRY_LINE+sufix) == -1) {
      ObjectCreate(ENTRY_LINE+sufix, OBJ_HLINE, 0, 0, entry);
      ObjectSet(ENTRY_LINE+sufix, OBJPROP_COLOR, entry_color);
      ObjectSet(ENTRY_LINE+sufix, OBJPROP_STYLE, entry_style);
      ObjectSet(ENTRY_LINE+sufix, OBJPROP_BACK, background);
   } else {
      ObjectSet(ENTRY_LINE+sufix, OBJPROP_PRICE1, entry);
   }

   if (ObjectFind(EXIT_LINE+sufix) == -1) {
      ObjectCreate(EXIT_LINE+sufix, OBJ_HLINE, 0, 0, exit);
      ObjectSet(EXIT_LINE+sufix, OBJPROP_COLOR, exit_color);
      ObjectSet(EXIT_LINE+sufix, OBJPROP_STYLE, exit_style);
      ObjectSet(EXIT_LINE+sufix, OBJPROP_BACK, background);
   } else {
      ObjectSet(EXIT_LINE+sufix, OBJPROP_PRICE1, exit);
   }
}