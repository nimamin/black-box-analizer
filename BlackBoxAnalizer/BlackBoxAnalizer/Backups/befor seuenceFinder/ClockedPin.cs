using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class ClockedPin
    {
        BoolStream[] boolStream;
        bool[][] pinTable;
        int lines;
        bool[] valid;        
        public bool[] Valid {get {return valid;}}
        int validLines;
        bool[] clockEnabled;
        int clockEnabledLines;
        public bool ClockEnabled { get { return clockEnabledLines > 0; } }
        public int ClockEnabledLines { get { return clockEnabledLines; } }

        public ClockedPin(bool[][] pinTable)
        {
            this.pinTable = pinTable;
            
            lines = pinTable.Length;
            clockEnabled = new bool[lines];
            boolStream = new BoolStream[lines];
            valid = new bool[lines];

            clockEnabledLines = 0; validLines = 0;
            BoolStream b;
            for (int l = 0; l < lines; l++)
            {
                boolStream[l] = b = new BoolStream(pinTable[l]);
                if ((b.IsFixPartNull) && (b.RepetitiveCount == 1))
                {
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

        public override string ToString()
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
    }
}
