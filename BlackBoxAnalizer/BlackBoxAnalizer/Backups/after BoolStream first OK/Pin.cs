using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class Pin
    {

        #region Declaration

        //int relatedPinsCount;
        int pinNumber;
        //bool[] trueTable;
        //bool[] rowMask;
        //int high;
        bool CkEn;
        //bool Logic;
        //int[] RelatedPins;
        //bool[][] bin;
        //bool[][] binMask;
        bool[][] pinTable;
        int lines;
        BoolStream[] boolStream;

        public Pin(int pinNumber, bool[][] pinTable)
        {
            this.pinNumber = pinNumber;
            this.pinTable = pinTable;

            lines = pinTable.Length;
            boolStream = new BoolStream[lines];
            for (int l = 0; l < lines; l++)
            {
                boolStream[l] = new BoolStream(pinTable[l]);
            }
        }

        #endregion

        #region Properties

        public bool ClockEnabled { get { return CkEn; } }
        public int PinNumber { get { return pinNumber; } }
       
        #endregion
    }

    struct BoolStream
    {
        public bool[] Fix;
        public bool[] Repetitive;

        public BoolStream(bool[] p)
        {
            Fix = null;
            Repetitive = null;

            int columns = p.Length;
            bool equalFlag = true;

            for (int f = 0; f < columns; f++)
            {
                // f starts from beginning to measure fixed part of the stream.
                int middle = f + (columns - f + 1) * 2 / 3; // for ending the comparision at the half of the stream.
                for (int i = f; i < middle; i++)
                {
                    // i starts from the end of the fixed part and is the end of the Repetitive part that mast be compared with remained stream after i.
                    int r = i - f + 1; // for measuring the length of the repetitive part.
                    for (int j = 1; j <= middle / r + 1; j++)
                    {
                        // j couts the number of correct maches after every compare.
                        //equalFlag = true;
                        for (int k = 0; k < r; k++)
                        {
                            // for each compare we need k to comparing the field.
                            if (f + k + j * r > columns - 1) continue;
                            if (p[f + k] != p[f + k + j * r])
                            {
                                equalFlag = false;
                                break;
                            }
                            else equalFlag = true;
                        }
                        if (equalFlag == false) break;
                    }

                    if (equalFlag == true)
                    {
                        Repetitive = new bool[r];
                        for (int j = 0; j < r; j++)
                        {
                            Repetitive[j] = p[f + j];
                        }
                        break;
                    }
                }

                if (equalFlag == true)
                {
                    Fix = new bool[f];
                    for (int i = 0; i < f; i++)
                    {
                        Fix[i] = p[i];
                    }
                    break;
                }
            }

            if (equalFlag == false)
            {
                Repetitive = null;
                Fix = new bool[columns];
                for (int i = 0; i < columns; i++)
                {
                    Fix[i] = p[i];
                }
            }
        }

        public override string ToString()
        {
            string s;

            s = "Fix part: ";
            if (Fix != null && Fix.Length > 0)
                foreach (bool b in Fix)
                    if (b) s += '1'; else s += '0';
            else s += "null";

            s += " \nRepetitive part: ";
            if (Repetitive != null && Repetitive.Length > 0)
                foreach (bool b in Repetitive)
                    if (b) s += '1'; else s += '0';
            else s += "null";

            return s;
        }
    }
}
