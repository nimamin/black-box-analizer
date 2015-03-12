
namespace BlackBoxAnalizer
{
    class Pin
    {
        public static int[] inPinCode = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 19, 18, 17, 16, 15, 14, 13, 12 };
        public static int[] outPinCode = { 19, 18, 17, 16, 15, 14, 13, 12 };
        int pinNumber;
        public int PinNumber { get { return pinNumber; } }
        bool[] trueTable;
        int lines;
        int inMask, outMask;
        int outPinCount, inPinCount;
        int[] outPinNumbers, inPinNumbers;
        ClockedPin clockedPin;
        public ClockedPin ClockedPin { get { return clockedPin; } }
        PIQueue piQueue;

        public Pin(int pinNumber, bool[][] pinTable, int inMask, int outMask)
        {
            this.pinNumber = pinNumber;
            this.inMask = inMask;
            this.outMask = outMask;

            calculateInOutPins();
            clockedPin = new ClockedPin(pinTable);

            int tlines = pinTable.Length;
            lines = tlines * 2;
            trueTable = new bool[lines];
            for (int l = 0; l < tlines; l++)
            {
                if (clockedPin.Valid[l])
                {
                    trueTable[l * 2] = pinTable[l][0];
                    trueTable[l * 2 + 1] = pinTable[l][1];
                }
            }

            piQueue = new PIQueue(trueTable, false);
            piQueue.Normalize();
            piQueue.Minimize();
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

            s += "\r\nPin" + Pin.outPinCode[pinNumber];
            if (clockedPin.ClockEnabled) s += " = " + clockedPin;
            else
            {
                s += " " + piQueue.RelatedPins() + " = ";
                if (piQueue != null) s += piQueue.ToPinString();
            }

            return s;
        }
    }
}
