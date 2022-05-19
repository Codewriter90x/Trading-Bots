#include <Trade/Trade.mqh>

CTrade trade;

//--- input parameters
input uint     InpPeriod   =  14;   // Period
input int      VI_Length   = 14; 
//--- indicator buffers

void OnInit()
{

   printf("ACCOUNT_BALANCE = %G",AccountInfoDouble(ACCOUNT_BALANCE));
printf("ACCOUNT_CREDIT = %G",AccountInfoDouble(ACCOUNT_CREDIT));
printf("ACCOUNT_PROFIT = %G",AccountInfoDouble(ACCOUNT_PROFIT));
printf("ACCOUNT_EQUITY = %G",AccountInfoDouble(ACCOUNT_EQUITY));
printf("ACCOUNT_MARGIN = %G",AccountInfoDouble(ACCOUNT_MARGIN));


   /*double volume=0.1;
   
   int    digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS); // number of decimal places
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);         // point
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);             // current buy price
   double price=1000*point;                                 // unnormalized open price
   price=NormalizeDouble(price,digits);                      // normalizing open price
   int SL_pips=0;                                         // Stop Loss in points
   int TP_pips=0;                                         // Take Profit in points
   double SL=price-SL_pips*point;                           // unnormalized SL value
   SL=NormalizeDouble(SL,digits);                            // normalizing Stop Loss
   double TP=price+TP_pips*point;                           // unnormalized TP value
   TP=NormalizeDouble(TP,digits);                            // normalizing Take Profit
   datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_M5);
   string comment=StringFormat("Buy Limit %s %G lots at %s, SL=%s TP=%s",
                               _Symbol,volume,
                               DoubleToString(price,digits),
                               DoubleToString(SL,digits),
                               DoubleToString(TP,digits));
//--- everything is ready, sending a Buy Limit pending order to the server
   if(!trade.BuyLimit(volume,price,_Symbol,SL,TP,ORDER_TIME_GTC,expiration,comment))
     {
      //--- failure message
      Print("BuyLimit() method failed. Return code=",trade.ResultRetcode(),
            ". Code description: ",trade.ResultRetcodeDescription());
     }
   else
     {
      Print("BuyLimit() method executed successfully. Return code=",trade.ResultRetcode(),
            " (",trade.ResultRetcodeDescription(),")");
     }
     */
  /*  printf("ACCOUNT_BALANCE = %G",AccountInfoDouble(ACCOUNT_BALANCE));
printf("ACCOUNT_CREDIT = %G",AccountInfoDouble(ACCOUNT_CREDIT));
printf("ACCOUNT_PROFIT = %G",AccountInfoDouble(ACCOUNT_PROFIT));
printf("ACCOUNT_EQUITY = %G",AccountInfoDouble(ACCOUNT_EQUITY));
printf("ACCOUNT_MARGIN = %G",AccountInfoDouble(ACCOUNT_MARGIN));*/
}

void OnTick(void)
{
   //printf(GetRSI());
   //GetStrochastic();
   //trade.Buy(0.10, NULL, Bid, )  
   //GetVortex(14);
   
   //printf(iHigh(_Symbol, _Period,0));
   //printf(iLow(_Symbol, _Period,0));
    //   GetVortex(14);
}

void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
  {
   
  }

double GetRSI() {
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
   
   //string signal = "";
   
   double myRSIArray[];
   ArraySetAsSeries(myRSIArray,true);
   
   int myRSIDefinition = iRSI(_Symbol, _Period, 14, PRICE_CLOSE);
   
   CopyBuffer(myRSIDefinition, 0, 0, 3, myRSIArray);
   
   
   double myRSIValue = NormalizeDouble(myRSIArray[0],2);
   
   return myRSIValue;
}

double GetStrochastic() {
   double KArray[];
   double DArray[];
   
   //mi serve per girare l'array dalla candela corrente alla prima
   ArraySetAsSeries(KArray, true);
   ArraySetAsSeries(DArray, true);   
   
   int StochasticDefinition = iStochastic(_Symbol, _Period, 5,3,3, MODE_SMA, STO_LOWHIGH);
   
   CopyBuffer(StochasticDefinition, 0,0,3, KArray);
   CopyBuffer(StochasticDefinition, 1,0,3, DArray);
   
   //calcolo il valore per la candela corrente
   double KValue0 = KArray[0];
   double DValue0 = DArray[0];
   
   //calcolo il valore dell' ultima candela
   double KValue1 = KArray[1];
   double DValue1 = DArray[1];
   
   printf("K:" + KValue0 + " D:" + DValue0);
   
   return 0;
}

void GetVortex(int period) {
   
   double High[15], Low[15], Close[15];
    ArrayInitialize(High,0);
    ArrayInitialize(Low,0);
    ArrayInitialize(Close,0);

    for(int i=0;i<=period;i++) {
       High[i] = iHigh(_Symbol, _Period,i);
       Low[i] = iLow(_Symbol, _Period,i);
       Close[i] = iClose(_Symbol, _Period,i);
    }
    
    ArrayReverse(High,0,WHOLE_ARRAY);
    ArrayReverse(Low,0,WHOLE_ARRAY);
    ArrayReverse(Close,0,WHOLE_ARRAY);

    double PVM[15], MVM[15];
    ArrayInitialize(PVM,0);
    ArrayInitialize(MVM,0);
    for(int i=1;i<=period;i++) {
       PVM[i] = fabs(High[i] - Low[i-1]);
       MVM[i] = fabs(Low[i] - High[i-1]);
    }

    double TR[15];
    ArrayInitialize(TR,0);
    for(int i=1;i<=period;i++) {
        double tmp1 = High[i]-Low[i];
        double tmpa2 = fabs(High[i] - Close[i-1]);
        double tmpa3 = fabs(Low[i] - Close[i-1]);        
        double tmp4 = MathMax(tmp1,tmpa2);
        double tmp5 = MathMax(tmp4,tmpa3);
        
        TR[i] = tmp5;
    }

    double PVMP=0, MVMP=0;
    for(int i=1;i<=period;i++) {
        PVMP += PVM[i];
        MVMP += MVM[i];
    }

    double TRP =0;
    for(int i=1;i<=period;i++) {
        TRP += TR[i];       
    }

    double PVIP =100.0* PVMP / TRP;
    double MVIP =100.0* MVMP / TRP;
    
   /*for(int i=0;i<=period;i++) {
      if(i==period) {
         printf(High[i] + " | " + Low[i] + " | " + Close[i] + " | " + PVM[i] + " | " + MVM[i] + "  | " + PVMP + " | " + MVMP + " | " + TR[i] + " | "+ TRP+ " | "+PVIP+" | " +MVIP+ " ;");
      }
      else {
         printf(High[i] + " | " + Low[i] + " | " + Close[i] + " | " + PVM[i] + " | " + MVM[i] + "  | -/- | -/- | " + TR[i] + " | -/- | -/- | -/- ");
      }
   }

printf("-----------------");
printf("-----------------");
printf("-----------------");*/
    printf(PVIP + " " + MVIP);
}
