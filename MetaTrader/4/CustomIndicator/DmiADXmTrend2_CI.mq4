//+------------------------------------------------------------------+
//|                                             DmiADXmTrend2_CI.mq4 |
//|                                                        KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_separate_window
#property indicator_minimum -4.2
#property indicator_maximum 4.2
#property indicator_buffers 1
#property indicator_color1 Green

double buffer[];
//+------------------------------------------------------------------+
int init() {
    SetIndexStyle(0, DRAW_LINE);
    SetIndexBuffer(0, buffer);

    return(0);
}

//+------------------------------------------------------------------+
int start() {
    static datetime lastAlertTime = EMPTY;

    int limit = MathMin((Bars-3), Bars-IndicatorCounted());
    int result;

    for (int i=0; i<limit; i++) {
        result = getPriceDirection(i);
        result += getADXmDirection(i);
        result += getDmiPlusDirection(i);
        result += getDmiMinusDirection(i);
        buffer[i] = result;
    }

    return(0);
}
//+------------------------------------------------------------------+
int getPriceDirection(int idx) {

    if (Close[idx+2] < Close[idx+1] && Close[idx+1] > Close[idx] && Close[idx+2] < Close[idx]) {
        return (-1);
    } else
    if (Close[idx+2] > Close[idx+1] && Close[idx+1] < Close[idx] && Close[idx+2] > Close[idx]) {
        return (1);
    }

    return (0);
}

int getADXmDirection(int idx) {
    string chartName = "ADXm";

    double adx;
    adx = iCustom(NULL, 0, chartName, 14, 20, 2, idx);
if (idx == 30)
Comment(adx);
    if (adx == 0.0) {
        return (1);
    } else {
        return (-1);
    }
    return (0);
}

int getDmiPlusDirection(int idx) {
    string chartName = "DMI+";
    int dmiPlusLine = 0;  // 0:Line number of DMI Plus in DMI+ chart

    double dmip1, dmip2, dmip3;

    dmip1 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+0);
    dmip2 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+1);
    dmip3 = iCustom(NULL, 0, chartName, dmiPlusLine, idx+2);

    if (dmip3 < dmip2 && dmip2 > dmip1) {
        return (-1);
    } else
    if (dmip3 > dmip2 && dmip2 < dmip1) {
        return (1);
    }

    return (0);
}

int getDmiMinusDirection(int idx) {
    string chartName = "DMI+";
    int dmiMinusLine = 1;  // 0:Line number of DMI minus in DMI+ chart

    double dmim1, dmim2, dmim3;

    dmim1 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+0);
    dmim2 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+1);
    dmim3 = iCustom(NULL, 0, chartName, dmiMinusLine, idx+2);

    if (dmim3 < dmim2 && dmim2 > dmim1) {
        return (1);
    } else
    if (dmim3 > dmim2 && dmim2 < dmim1) {
        return (-1);
    }
    return (0);
}

