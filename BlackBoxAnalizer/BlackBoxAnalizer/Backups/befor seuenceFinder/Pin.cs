
namespace BlackBoxAnalizer
{
    class Pin
    {
        int pinNumber;
        public int PinNumber { get { return pinNumber; } }
        bool[] trueTable;
        int trueLines;
        bool[][] pinTable;
        int lines;
        int inMask, outMask;
        int outPinCount, inPinCount;
        int[] outPinNumbers, inPinNumbers;
        ClockedPin clockedPin;
        PIQueue piQueue;
        int[] inPinCode = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 19, 18, 17, 16, 15, 14, 13, 12 };
        int[] outPinCode = { 19, 18, 17, 16, 15, 14, 13, 12 };

        public Pin(int pinNumber, bool[][] pinTable, int inMask, int outMask)
        {
            this.pinNumber = pinNumber;
            this.pinTable = pinTable;
            this.inMask = inMask;
            this.outMask = outMask;

            calculateInOutPins();
            clockedPin = new ClockedPin(pinTable);

            int tlines = pinTable.Length;
            lines = tlines * 2;
            trueTable = new bool[lines];
            trueLines = 0;
            for (int l = 0; l < tlines; l++)
            {
                if (clockedPin.Valid[l])
                {
                    if (trueTable[l * 2] = pinTable[l][0]) trueLines++;
                    if (trueTable[l * 2 + 1] = pinTable[l][1]) trueLines++;
                }
            }

            if (trueLines > 0)
            {
                int[] minterms = new int[trueLines];
                int m = 0;
                for (int l = 0; l < lines; l++)
                {
                    if (trueTable[l]) minterms[m++] = l;
                }
                piQueue = new PIQueue(minterms, inPinCount);
                piQueue.Normalize();
                piQueue.Minimize(minterms);
            }
        }

        void calculateInOutPins()
        {
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
        }

        public override string ToString()
        {
            string s = "";

            s += "\n\rPin" + pinNumber + ": ";
            if (clockedPin.ClockEnabled) s += "\n\r    " + clockedPin;
            if (piQueue != null) s += "\n\r    " + piQueue.GetAlphabetString();

            return s;
        }
    }
}
