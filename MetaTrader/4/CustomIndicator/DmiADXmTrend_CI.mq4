//+------------------------------------------------------------------+
//|                                              DmiADXmTrend_CI.mq4 |
//|                                                        KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_separate_window
#property indicator_minimum -5
#property indicator_maximum 5
#property indicator_buffers 8

double up1[];
double up2[];
double up3[];
double up4[];
double down1[];
double down2[];
double down3[];
double down4[];
//+------------------------------------------------------------------+
int init() {
    for (int i=0; i<4; i++) {
        SetIndexStyle(i, DRAW_ARROW, EMPTY, EMPTY, Green);
        SetIndexArrow(i, 235);
        SetIndexArrow(i, EMPTY_VALUE);
    }
    for (i=4; i<8; i++) {
        SetIndexStyle(i, DRAW_ARROW, EMPTY, EMPTY, Red);
        SetIndexArrow(i, 234);
        SetIndexArrow(i, EMPTY_VALUE);
    }
        SetIndexStyle(0, DRAW_ARROW, EMPTY, EMPTY, Gold);
        SetIndexStyle(4, DRAW_ARROW, EMPTY, EMPTY, Gold);

    SetIndexBuffer(0, up1);
    SetIndexBuffer(1, up2);
    SetIndexBuffer(2, up3);
    SetIndexBuffer(3, up4);
    SetIndexBuffer(4, down1);
    SetIndexBuffer(5, down2);
    SetIndexBuffer(6, down3);
    SetIndexBuffer(7, down4);

    return(0);
}

//+------------------------------------------------------------------+
int start() {
    static datetime lastAlertTime = EMPTY;

    int limit = MathMin((Bars-3), Bars-IndicatorCounted());
    int result;

    for (int i=0; i<limit; i++) {
        result = getADXmDirection(i);
        if (result > 0) {
            up4[i]      = 4;
            down4[i]    = EMPTY_VALUE;
        } else if (result < 0) {
            down4[i]    = -4;
            up4[i]      = EMPTY_VALUE;
        } else {
            up4[i]      = EMPTY_VALUE;
            down4[i]    = EMPTY_VALUE;
        }

        result = getDmiMinusDirection(i);
        if (result > 0) {
            up3[i]      = 3;
            down3[i]    = EMPTY_VALUE;
        } else if (result < 0) {
            down3[i]    = -3;
            up3[i]      = EMPTY_VALUE;
        } else {
            up3[i]      = EMPTY_VALUE;
            down3[i]    = EMPTY_VALUE;
        }

        result = getDmiPlusDirection(i);
        if (result > 0) {
            up2[i]      = 2;
            down2[i]    = EMPTY_VALUE;
        } else if (result < 0) {
            down2[i]    = -2;
            up2[i]      = EMPTY_VALUE;
        } else {
            up2[i]      = EMPTY_VALUE;
            down2[i]    = EMPTY_VALUE;
        }

        result = getPriceDirection(i);
        if (result > 0) {
            up1[i]      = 1;
            down1[i]    = EMPTY_VALUE;
        } else if (result < 0) {
            down1[i]    = -1;
            up1[i]      = EMPTY_VALUE;
        } else {
            up1[i]      = EMPTY_VALUE;
            down1[i]    = EMPTY_VALUE;
        }
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

