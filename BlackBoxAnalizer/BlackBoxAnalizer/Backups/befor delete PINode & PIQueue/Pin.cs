
namespace BlackBoxAnalizer
{
    class Pin
    {
        //int relatedPinsCount;
        int pinNumber;
        bool[] trueTable;
        bool[] valid;
        int validLines;
        int trueLines;
        int clockEnabledLines;
        //int high;
        bool[] clockEnabled;
        //int[] RelatedPins;
        //bool[][] bin;
        //bool[][] binMask;
        bool[][] pinTable;
        int lines;
        BoolStream[] boolStream;

        public Pin(int pinNumber, bool[][] pinTable)
        {
            BoolStream b;

            this.pinNumber = pinNumber;
            this.pinTable = pinTable;

            lines = pinTable.Length;

            trueTable = new bool[lines];
            valid = new bool[lines];
            clockEnabled = new bool[lines];
            boolStream = new BoolStream[lines];

            validLines = 0; trueLines = 0; clockEnabledLines = 0;

            for (int l = 0; l < lines; l++)
            {
                boolStream[l] = b = new BoolStream(pinTable[l]);
                if ((b.IsFixPartNull) && (b.RepetitiveCount == 1))
                {
                    trueTable[l] = b.Repetitive[0];
                    if (trueTable[l]) trueLines++;
                    valid[l] = true;
                    validLines++;
                }
                else if ((b.RepetitiveCount > 1))
                {
                    clockEnabled[l] = true;
                    clockEnabledLines++;
                }
            }
        }

        public string GetClockSituation()
        {
            string s = "";

            if (clockEnabledLines > 0)
            {
                bool clockEquivalent = true;
                int l1;
                for (l1 = 0; l1 < lines; l1++)
                    if (clockEnabled[l1]) break;
                for (int l2 = l1 + 1; l2 < lines; l2++)
                {
                    if (clockEnabled[l2])
                        clockEquivalent &= (BoolStream.IsEquivalent(boolStream[l1], boolStream[l2]));
                }

                if (clockEquivalent)
                {
                    // FIX ME // FIX ME // FIX ME // FIX ME // FIX ME // FIX ME // add code for counters.
                    if (clockEnabledLines == lines)
                        s += "Clock is always enabled and in all lines is equivalent. " + boolStream[l1];
                    else
                        s += "Clock is enabled in " + (clockEnabledLines * 100 / lines) + "% of lines and is equivalent. " + boolStream[l1];
                }
                else
                {
                    s += "Clock is enabled:\n\r";
                    for (int l = 0; l < lines; l++)
                    {
                        s += l + ": " + boolStream[l].ToString() + "\n\r";
                    }
                }
            }
            
            return s;
        }

        public string GetTrueTable()
        {
            string s = "";

            for (int l = 0; l < lines; l++)
            {
                s += l + ": ";
                if (clockEnabled[l]) ;
                else if (valid[l]) s += "Always:" + trueTable[l];
                else s += "None sence:" + boolStream[l].ToString();
                s += "\n\r";
            }

            return s;
        }

        public string GetQM(int inPinCount)
        {
            int[] minterms = new int[trueLines];
            int i = 0;
            for (int l = 0; l < lines; l++)
            {
                if (valid[l] && trueTable[l]) minterms[i++] = l;
            }

            return QueenMcClaussy.GetString(minterms, inPinCount);
        }

        public override string ToString()
        {
            string s = "";

            s += GetClockSituation() + "\n\r" + GetTrueTable() + "\n\r";

            return s;
        }
    }

    
}
