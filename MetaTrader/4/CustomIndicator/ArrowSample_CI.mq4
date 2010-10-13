//+------------------------------------------------------------------+
//|                                               ArrowSample_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 1

#define WINDOW_MAIN  0
#define PREFIX       "ArrowSample_CI"

extern color   ExtColor       = Red;
extern int     ExtFontSize    = 9;

extern int     ExtMarginLeft  = 10;
extern int     ExtMarginTop   = 10;

extern double  ExtColMargin   = 4.5;
extern double  ExtRowMargin   = 2.2;

extern int     ExtLineNum     = 10;

extern int     ExtArrowType   = 234;

double buffer[];

//+------------------------------------------------------------------+
int init() {

   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0, ExtArrowType);
   SetIndexBuffer(0, buffer);

   setLabelTable();
}
//+------------------------------------------------------------------+
int deinit() {

   delete();
   
	return(0);
}

//+------------------------------------------------------------------+
int start() {
   static bool runtimeInit = true;
   
   if (runtimeInit) {
      SetIndexStyle(0, DRAW_ARROW, EMPTY, EMPTY, ExtColor);

      runtimeInit = false;
   }

   if (IndicatorCounted() != 1) {
      ArrayInitialize(buffer, EMPTY_VALUE);
   }

   for (int i=0; i<100; i+=10) {
      buffer[i] = High[i];
   }

   setArrows();
   return(0);
}

//+------------------------------------------------------------------+
void setArrows() {
   for (int i=0; i<6; i++) {
      setArrow(i);
   }
}
void setArrow(int i) {
   string name;

   name = PREFIX+"arrow"+i;
   if (ObjectCreate(name, OBJ_ARROW, WINDOW_MAIN, Time[i*10], Low[i*10])) {
      ObjectSet(name, OBJPROP_ARROWCODE, i+1);
   }
}

//+------------------------------------------------------------------+
void setLabelTable() {
   int x, y;
   int start=33, limit=255;
   int minusMargin=(start/ExtLineNum)*(ExtFontSize*ExtColMargin);

   for (int i=start; i<=limit; i++) {
      x = (i/ExtLineNum)*(ExtFontSize*ExtColMargin)   // base x point
        - minusMargin                                 // not start 0
        + ExtMarginLeft;

      y = (i*ExtFontSize*ExtRowMargin)                // base y point
        - (i/ExtLineNum)*(ExtFontSize*ExtRowMargin*ExtLineNum) // carriage return
        + ExtMarginTop;

      setLabel(x, y, i);
   }
}

void setLabel(int x, int y, int no) {
   string name;

   name = PREFIX+"no"+no;
   if (ObjectCreate(name, OBJ_LABEL, WINDOW_MAIN, NULL, NULL)) {
      ObjectSetText(name, DoubleToStr(no, 0), ExtFontSize, "Courer New", ExtColor);
      ObjectSet(name, OBJPROP_XDISTANCE, x);
      ObjectSet(name, OBJPROP_YDISTANCE, y);
   }

   name = PREFIX+"text"+no;
   if (ObjectCreate(name, OBJ_LABEL, WINDOW_MAIN, NULL, NULL)) {
      ObjectSetText(name, CharToStr(no), ExtFontSize, "WingDings", ExtColor);
      ObjectSet(name, OBJPROP_XDISTANCE, x+(ExtFontSize*2.5));
      ObjectSet(name, OBJPROP_YDISTANCE, y);
   }
}

//+------------------------------------------------------------------+
void delete() {
   int allobjectsNum = ObjectsTotal();
   string name;

   for (int i=allobjectsNum-1; i>=0; i--) {
      name = ObjectName(i);

      if (startWith(name, PREFIX+"no")) {
         ObjectDelete(name);
      }

      if (startWith(name, PREFIX+"text")) {
         ObjectDelete(name);
      }

      if (startWith(name, PREFIX+"arrow")) {
         ObjectDelete(name);
      }
   }
}

bool startWith(string text, string prefix) {
   int   prefixLen = StringLen(prefix);

   return (StringSubstr(text, 0, prefixLen) == prefix);
}

