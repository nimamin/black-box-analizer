﻿using System;

namespace BlackBoxAnalizer
{
    class Analizer
    {
        int[,] parsedTable;
        int lines, columns;
        int outPinCount, inPinCount;
        int inMask, outMask;
        Pin[] pins;
        int[] lineIndexes;
        SequenceFinder sequenceFinder;
        bool clock = false;

        public string Parse(System.IO.StreamReader sr)
        {
            String input;
            string[] s;

            if ((input = sr.ReadLine()) == null) return "File is Empty.";
            if ((input[0] == 'g') || (input[0] == 'G'))
                if ((input = sr.ReadLine()) == null) return "There is nothing after g.";

            s = input.Split('\t');
            if (s.Length < 3) return "Initial parameters are not enough.";
            if (s[0][0] == 'I') inPinCount = Int32.Parse(s[0].Remove(0, 2)); else return "There is no I parameter.";
            if (s[1][0] == 'Q') outPinCount = Int32.Parse(s[1].Remove(0, 2)); else return "There is no Q parameter.";
            if (s[2][0] == 'C') columns = Int32.Parse(s[2].Remove(0, 2));
            else if ((s[2][0] == 'L') && (s[3][0] == 'C')) columns = Int32.Parse(s[3].Remove(0, 2)); 
            else return "There is no C parameter.";

            if (columns == 0) return "Columns is equal with 0.";
            if ((input = sr.ReadLine()) == null) return "There is nothing after initial parameters.";
            s = input.Split('\t');
            if (s.Length < 2) return "Mask parameters are not enough.";
            string[] str = s[0].Split(':');
            if (str[0] == "In mask") inMask = Int32.Parse(str[1], System.Globalization.NumberStyles.HexNumber); else return "There is no In mask parameter.";
            str = s[1].Split(':');
            if (str[0] == "Out mask") outMask = Int32.Parse(str[1], System.Globalization.NumberStyles.HexNumber); else return "There is no Out mask parameter.";

            columns += 2;
            if ((inMask & 1) > 0)
                lines = 1 << (inPinCount - 1);
            else lines = 1 << inPinCount;

            lineIndexes = new int[lines];
            parsedTable = new int[lines, columns - 1];

            for (int l = 0; l < lines; l++)
            {
                input = sr.ReadLine();
                if (input == null) return "There is not enough lines.";

                s = input.Split('\t');
                if (s.Length < columns - 1) return "Line nomber: " + l + "There is not enough columns.";
                lineIndexes[l] = Int32.Parse(s[0].Remove(3), System.Globalization.NumberStyles.HexNumber);

                for (int column = 0; column < s.Length - 2; column++)
                {
                    int x = Int32.Parse(s[column + 1], System.Globalization.NumberStyles.HexNumber);
                    parsedTable[l, column] = x;
                }
            }

            if (parsedTable == null) return "The parsed table is empty. Please execute the Parse methode first.";
            return null;
        }

        public void Analize()
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

                pins[i] = new Pin(pinNumber, pinTable, inMask, outMask);
                pinNumber++;
            }

            foreach (Pin p in pins)
                clock |= p.TimingEnabled;

            if (clock)
            {
                sequenceFinder = new SequenceFinder(pins);
                sequenceFinder.GenerateSequence();
            }
        }

        public string GetResult() 
        {
            string s = "";
            foreach (Pin p in pins)
                s += p.ToString();
            if (clock) s += "\r\n\r\n" + sequenceFinder.ToString();
            return s;
        }

        public string GetMoreDetails(int i)
        {
            return "\r\n\r\nPin" + i + ": \r\n\r\n" + pins[i].GetMoreDetails();
        }

    }
}
