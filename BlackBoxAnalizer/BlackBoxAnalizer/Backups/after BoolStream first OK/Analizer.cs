using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class Analizer
    {
        int[,] parsedTable;
        int lines, columns;
        int outPinCount, inPinCount;/// change name to Pins
        //int[] outPinNumbers, inPinNumbers;
        int inMask, outMask;
        Pin[] pins;

        int[] lineIndexes;

        public bool Parse(System.IO.StreamReader sr)
        {
            String input;
            string[] s;

            if ((input = sr.ReadLine()) == null) return false;
            if ((input[0] == 'g') || (input[0] == 'G'))
                if ((input = sr.ReadLine()) == null) return false;

            s = input.Split('\t');
            if (s.Length < 3) return false;
            if (s[0][0] == 'I') inPinCount = Int32.Parse(s[0].Remove(0, 2)); else return false;
            if (s[1][0] == 'Q') outPinCount = Int32.Parse(s[1].Remove(0, 2)); else return false;
            if (s[2][0] == 'C') columns = Int32.Parse(s[2].Remove(0, 2)); else return false;

            if ((input = sr.ReadLine()) == null) return false;
            s = input.Split('\t');
            if (s.Length < 2) return false;
            string[] str = s[0].Split(':');
            if (str[0] == "In mask") inMask = Int32.Parse(str[1], System.Globalization.NumberStyles.HexNumber); else return false;
            str = s[1].Split(':');
            if (str[0] == "Out mask") outMask = Int32.Parse(str[1], System.Globalization.NumberStyles.HexNumber); else return false;

            columns += 2;
            lines = 1 << (inPinCount - 1);

            lineIndexes = new int[lines];
            parsedTable = new int[lines, columns];

            for (int l = 0; l < lines; l++)
            {
                input = sr.ReadLine();
                if (input == null) break;

                s = input.Split('\t');
                lineIndexes[l] = Int32.Parse(s[0].Remove(3), System.Globalization.NumberStyles.HexNumber);

                for (int column = 0; column < s.Length - 3; column++)
                {
                    int x = Int32.Parse(s[column + 1], System.Globalization.NumberStyles.HexNumber);
                    parsedTable[l, column] = x;
                }
            }

            return true;
        }

        void makePins()
        {
            pins = new Pin[outPinCount];

            int pinNumber = 0;
            int pinCode;
            bool[][] pinTable;
            for (int i = 0; i < outPinCount; i++)
            {
                pinCode = 1 << pinNumber;
                while ((pinCode & outMask) == 0) pinCode = 1 << ++pinNumber;

                pinTable = new bool[lines][];
                for (int l = 0; l < lines; l++)
                {
                    pinTable[l] = new bool[columns - 1];
                    for (int c = 0; c < columns - 1; c++)
                    {
                        if ((pinCode & parsedTable[l, c]) > 0)
                            pinTable[l][c] = true;
                        else
                            pinTable[l][c] = false;
                    }
                }

                pins[i] = new Pin(pinNumber, pinTable);
                pinNumber++;
            }
        }

        internal string GetResult()
        {
            if (parsedTable == null) return "The parsed table is empty. Please execute the Parse methode first.";

            makePins();

            throw new NotImplementedException();
        }
    }
}
