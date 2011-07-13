//+------------------------------------------------------------------+
//|                                                  DmiAlert_CI.mq4 |
//|                                                        KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 4

double upBuffer[];
double downBuffer[];
double upWeakBuffer[];
double downWeakBuffer[];

//+------------------------------------------------------------------+
int init() {
    SetIndexStyle(0, DRAW_ARROW, EMPTY, EMPTY, Green);
    SetIndexArrow(0, 233);
    SetIndexBuffer(0, upBuffer);
    SetIndexEmptyValue(0, EMPTY);

    SetIndexStyle(1, DRAW_ARROW, EMPTY, EMPTY, Red);
    SetIndexArrow(1, 234);
    SetIndexBuffer(1, downBuffer);
    SetIndexEmptyValue(1, EMPTY);

    SetIndexStyle(2, DRAW_ARROW, EMPTY, EMPTY, Gold);
    SetIndexArrow(2, 233);
    SetIndexBuffer(2, upWeakBuffer);
    SetIndexEmptyValue(2, EMPTY);

    SetIndexStyle(3, DRAW_ARROW, EMPTY, EMPTY, Gold);
    SetIndexArrow(3, 234);
    SetIndexBuffer(3, downWeakBuffer);
    SetIndexEmptyValue(3, EMPTY);

    return(0);
}

//+------------------------------------------------------------------+
int deinit() {
    return(0);
}

//+------------------------------------------------------------------+
int start() {
    static datetime lastAlertTime = EMPTY;

    int limit = MathMin((Bars-3), Bars-IndicatorCounted());
    for (int i=0; i<limit; i++) {
        bool direction = getDMI(i);

        if (direction) {
            if (i==0 && lastAlertTime != Time[0]) {
                lastAlertTime = Time[0];    // alert call only once
                PlaySound("Alert2.wav");
            }
            i+=1;   // skip next bar
        }
    }
    return(0);
}
//+------------------------------------------------------------------+

bool getDMI(int idx) {
    string chartName = "DMI+";
    int dmiPlusLine = 0;  // 0:Line number of DMI Plus in DMI+ chart
    int dmiMinusLine = 1;  // 0:Line number of DMI minus in DMI+ chart
    
    double dmip1, dmip2, dmip3;
    double dmim1, dmim2, dmim3;

    dmip1 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+0);
    dmip2 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+1);
    dmip3 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+2);
    dmim1 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+0);
    dmim2 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+1);
    dmim3 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+2);

    // up pettern
    if (dmim3 < dmim2 && dmim2 > dmim1) {
        if (dmip3 > dmip2 && dmip2 > dmip1) {
            upBuffer[idx] = Low[idx]-(Point*3);
            downBuffer[idx] = EMPTY;

            if (Close[idx+1] < Close[idx]) {
                upWeakBuffer[idx] = Low[idx]-(Point*5);
            }
            downWeakBuffer[idx] = EMPTY;

            // skip next bar
            upBuffer[idx+1] = EMPTY;
            downBuffer[idx+1] = EMPTY;
            upWeakBuffer[idx+1] = EMPTY;
            downWeakBuffer[idx+1] = EMPTY;

            return (true);
        }
    }
    // down pttern
    if (dmip3 < dmip2 && dmip2 > dmip1) {
        if (dmim3 > dmim2 && dmim2 > dmim1) {
            downBuffer[idx] = High[idx]+(Point*3);
            upBuffer[idx] = EMPTY;

            if (Close[idx+1] > Close[idx]) {
                downWeakBuffer[idx] = High[idx]+(Point*5);
            }
            upWeakBuffer[idx] = EMPTY;
 
            // skip next bar
            upBuffer[idx+1] = EMPTY;
            downBuffer[idx+1] = EMPTY;
            upWeakBuffer[idx+1] = EMPTY;
            downWeakBuffer[idx+1] = EMPTY;

            return (true);
        }
    }
    return (false);
}

