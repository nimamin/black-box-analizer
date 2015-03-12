
namespace BlackBoxAnalizer
{
    class Pin
    {
        public static int[] inPinCode = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 19, 18, 17, 16, 15, 14, 13, 12 };
        public static int[] outPinCode = { 19, 18, 17, 16, 15, 14, 13, 12 };
        int pinNumber;
        public int PinNumber { get { return pinNumber; } }
        bool[] trueTable;
        int inMask, outMask;
        int outPinCount, inPinCount;
        int[] outPinNumbers, inPinNumbers;
        PIQueue piQueue;
        BoolStream[] boolStream;
        public BoolStream[] BoolStream { get { return boolStream; } }
        int lines; public int Lines { get { return lines; } }
        int tlines; public int TimingLines { get { return tlines; } }
        bool clockEnabled;
        public bool ClockEnabled { get { return clockEnabled; } }
        bool[] timingLines;
        bool timingEnabled;
        public bool TimingEnabled { get { return timingEnabled; } }
        PinStatus pinStatus;
        public PinStatus PinStatus { get { return pinStatus; } }

        public Pin(int pinNumber, bool[][] pinTable, int inMask, int outMask)
        {
            this.pinNumber = pinNumber;
            this.inMask = inMask;
            this.outMask = outMask;

            tlines = pinTable.Length;
            lines = tlines * 2;
            trueTable = new bool[lines];
            timingLines = new bool[tlines];
            boolStream = new BoolStream[tlines];
            //calculateInOutPins();
            BoolStream b;
            for (int l = 0; l < tlines; l++)
            {
                boolStream[l] = b = new BoolStream(pinTable[l]);
                switch (b.PinStatus)
                {
                    case PinStatus.Null:
                        break;
                    case PinStatus.Combinatorial:
                        trueTable[l * 2] = pinTable[l][0];
                        trueTable[l * 2 + 1] = pinTable[l][1];
                        break;
                    case PinStatus.Register:
                        clockEnabled = true;
                        trueTable[l * 2] = trueTable[l * 2 + 1] = boolStream[l].Rep[0];
                        break;
                    case PinStatus.Counter:
                        timingLines[l] = true;
                        timingEnabled = true;
                        break;
                    default:
                        break;
                }
            }

            if (timingEnabled) pinStatus = BlackBoxAnalizer.PinStatus.Counter;
            else if (clockEnabled) pinStatus = BlackBoxAnalizer.PinStatus.Register;
            else pinStatus = BlackBoxAnalizer.PinStatus.Combinatorial;

            if (!timingEnabled)
            {
                piQueue = new PIQueue(trueTable, false);

                if (!mainForm.ShowProgressBar)
                {
                    piQueue.Normalize();
                    piQueue.Minimize();
                }
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

            s += "\r\nPin" + Pin.outPinCode[pinNumber];
            if (timingEnabled) s += " = " + pinStatus;
            else
            {
                s += " " + pinStatus + " " + piQueue.RelatedPins() + " = ";
                if (piQueue != null) s += piQueue.ToPinString();
            }

            return s;
        }

        public string GetMoreDetails()
        { 
            string s="";
            for (int i = 0; i < this.boolStream.Length; i++)
			{
                s += i + ": " + this.boolStream[i] + "\r\n";
			}
            return s;
        }
    }
}
