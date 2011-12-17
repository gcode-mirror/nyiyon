//+------------------------------------------------------------------+
//|                                                    AskBid_CI.mq4 |
//|                                      Copyright © 2010, KNYI,Jong |
//|                                     http://knyijong.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, KNYI,Jong"
#property link      "http://knyijong.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Yellow
#property indicator_color2 Yellow
#property indicator_color3 Blue
#property indicator_color4 Red


double bufferVola1[];
double bufferVola2[];
double bufferAsk[];
double bufferBid[];

extern bool ExtShowGuid = true;
extern double ExtDefaultLots = 1.1;
extern bool ExtShowVolatility = true;

//+------------------------------------------------------------------+
int init() {
	SetIndexStyle(0, DRAW_HISTOGRAM);
	SetIndexStyle(1, DRAW_HISTOGRAM);
	SetIndexStyle(2, DRAW_SECTION);
	SetIndexStyle(3, DRAW_SECTION);

	SetIndexShift(0, 5);
	SetIndexShift(1, 5);
	SetIndexShift(2, 2);
	SetIndexShift(3, 2);

	SetIndexBuffer(0, bufferVola1);
	SetIndexBuffer(1, bufferVola2);
	SetIndexBuffer(2, bufferAsk);
	SetIndexBuffer(3, bufferBid);

	return(0);
}

//+------------------------------------------------------------------+
int deinit() {
    return(0);
}

//+------------------------------------------------------------------+
int start() {

	if (IndicatorCounted() != 1) {
		ArrayInitialize(bufferAsk, EMPTY_VALUE);
		ArrayInitialize(bufferBid, EMPTY_VALUE);
		ArrayInitialize(bufferVola1, EMPTY_VALUE);
		ArrayInitialize(bufferVola2, EMPTY_VALUE);
	}

	bufferAsk[0] = Ask;
	bufferAsk[1] = Ask;
	bufferBid[0] = Bid;
	bufferBid[1] = Bid;

    guidTpLots();
    displayVolatility();

	return(0);
}
//+------------------------------------------------------------------+
void guidTpLots() {
    if (!ExtShowGuid) {
//        Comment("");
        return;
    }

    // guids suitable tp pips & take lots
    double tp = ((WindowPriceMax() - WindowPriceMin())/6.5)*1.4;
    tp = tp * (0.1/Point);
    double lot = (10 / tp) * ExtDefaultLots;

    Comment(DoubleToStr(tp, 1)+"pips * " + DoubleToStr(lot, 1) + "lots");
}
//+------------------------------------------------------------------+
void displayVolatility() {
    if (!ExtShowVolatility) return;

    double center = WindowPriceMax() - (WindowPriceMax() - WindowPriceMin()) / 2;
    double top = center + (5 *Point*10);
    double bottom = center - (5 *Point*10);

    bufferVola1[0] = top;
    bufferVola2[0] = bottom;
}

