
namespace BlackBoxAnalizer
{
    class Pin
    {
        int pinNumber;
        bool[] trueTable;
        bool[] valid;
        int validLines;
        int trueLines;
        int clockEnabledLines;
        bool[] clockEnabled;
        bool[][] pinTable;
        int lines;
        int inMask, outMask;
        int outPinCount, inPinCount;
        int[] outPinNumbers, inPinNumbers;
        BoolStream[] boolStream;
        int[] inPinCode = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 19, 18, 17, 16, 15, 14, 13, 12 };
        int[] outPinCode = { 19, 18, 17, 16, 15, 14, 13, 12 };

        public Pin(int pinNumber, bool[][] pinTable, int inMask, int outMask)
        {
            BoolStream b;

            this.pinNumber = pinNumber;
            this.pinTable = pinTable;
            this.inMask = inMask;
            this.outMask = outMask;

            inPinCount = 0;
            for (int i = 0; i < 18; i++)
                if ((inMask & (1 << i)) > 0) inPinCount++;
            inPinNumbers = new int[inPinCount];
            int k = 0;
            for (int i = 0; i < 18; i++)
                if ((inMask & (1 << i)) > 0) inPinNumbers[k++] = i;

            outPinCount = 0;
            for (int i = 0; i < 8; i++)
                if ((outMask & (1 << i)) > 0) outPinCount++;
            outPinNumbers = new int[outPinCount];
            k = 0;
            for (int i = 0; i < 8; i++)
                if ((outMask & (1 << i)) > 0) outPinNumbers[k++] = i;

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

        public int PinNumber { get { return pinNumber; } }

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
                        s += "Clock is always enabled: " + boolStream[l1];
                    else
                        s += "Clock is enabled in " + (clockEnabledLines * 100 / lines) + "% of lines: " + boolStream[l1];
                }
                else
                {
                    s += "Clock is enabled:";
                    for (int l = 0; l < lines; l++)
                    {
                        s += "\n\r        " + l + ": " + boolStream[l].ToString();
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
                if (!clockEnabled[l])
                {
                    if (valid[l]) s += "Always:" + trueTable[l];
                    else s += "None sence:" + boolStream[l].ToString();
                }
                s += "\n\r";
            }

            return s;
        }
        public string GetQM()
        {
            if (trueLines == 0) return "";
            int[] minterms = new int[trueLines];
            int i = 0;
            for (int l = 0; l < lines; l++)
            {
                if (valid[l] && trueTable[l]) minterms[i++] = l;
            }
            if (minterms == null) return "";
            return QueenMcClaussy.GetString(minterms, inPinCount);
        }
        public override string ToString()
        {
            string s = "";

            s += "\n\rPin" + pinNumber + ": " + "\n\r    " + GetClockSituation() + "\n\r    " + GetQM();

            return s;
        }
    }
}
