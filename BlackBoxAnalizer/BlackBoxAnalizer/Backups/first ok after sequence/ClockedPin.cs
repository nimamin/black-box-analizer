using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class ClockedPin
    {
        BoolStream[] boolStream;
        public BoolStream[] BoolStream { get { return boolStream; } }
        int lines; public int Lines { get { return lines; } }
        bool[] valid;        
        public bool[] Valid {get {return valid;}}
        int validLines;
        bool[] clockEnabled;
        int clockEnabledLines;
        public bool ClockEnabled { get { return clockEnabledLines > 0; } }

        public ClockedPin(bool[][] pinTable)
        {
            lines = pinTable.Length;
            clockEnabled = new bool[lines];
            boolStream = new BoolStream[lines];
            valid = new bool[lines];

            clockEnabledLines = 0; validLines = 0;
            BoolStream b;
            for (int l = 0; l < lines; l++)
            {
                boolStream[l] = b = new BoolStream(pinTable[l]);
                if ((b.RepetitiveCount > 1))
                {
                    clockEnabled[l] = true;
                    clockEnabledLines++;
                }
                else 
                {
                    valid[l] = true;
                    validLines++;
                }
            }
        }

        public override string ToString()
        {
            string s = "";

            if (clockEnabledLines > 0)
            {
                s += "Clock is enabled.";
            }

            return s;
        }
    }
}
