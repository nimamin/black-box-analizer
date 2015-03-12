using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BlackBoxAnalizer
{
    class SequenceFinder
    {
        int inPinCount, lines;
        BoolStream[][] boolStreams;
        Sequence[] sequence;
        bool[] cary;
        Sequence[] minSequences;
        PIQueue[] seqPIQueue;
        int diffCounter;
        bool[] clockEnabled;

        public SequenceFinder(Pin[] pins)
        {
            inPinCount = pins.Length;
            lines = pins[0].ClockedPin.Lines;
            boolStreams = new BoolStream[inPinCount][];
            clockEnabled = new bool[inPinCount];
            for (int i = 0; i < inPinCount; i++)
                if (clockEnabled[i] = pins[i].ClockedPin.ClockEnabled) boolStreams[i] = pins[i].ClockedPin.BoolStream;

            cary = new bool[lines];
            sequence = new Sequence[lines];
        }

        public void GenerateSequence()
        {
            for (int l = 0; l < lines; l++)
            {
                int[] sort = bubleSegmentSort(l);
                BoolStream[] b = new BoolStream[sort.Length];
                for (int i = 0; i < sort.Length; i++)
                    b[i] = boolStreams[sort[i]][l];
                sequence[l] = new Sequence(b, cary[l], sort);
            }

            diffCounter = 1;
            int[] diffIndex = new int[lines];
            diffIndex[0] = 0;
            for (int l = 1; l < lines; l++)
            { 
                bool equal = false;
                for (int i = 0; i < diffCounter; i++)
                    equal |= (sequence[l] == sequence[diffIndex[i]]);
                if (equal == false) diffIndex[diffCounter++] = l;
            }

            minSequences = new Sequence[diffCounter];
            seqPIQueue = new PIQueue[diffCounter];
            for (int i = 0; i < diffCounter; i++)
            {
                minSequences[i] = sequence[diffIndex[i]];
                bool[] trueTable = new bool[lines];
                for (int l = 0; l < lines; l++)
                    if (minSequences[i] == sequence[l]) trueTable[l] = true;
                seqPIQueue[i] = new PIQueue(trueTable, true);

                if (!mainForm.ShowProgressBar)
                {
                    seqPIQueue[i].Normalize();
                    seqPIQueue[i].Minimize();
                }
            }
        }

        int[] bubleSegmentSort(int l)
        {
            int cp = 0;
            for (int i = 0; i < inPinCount; i++)
                if (clockEnabled[i]) cp++;

            BoolStream b;
            int[] sort = new int[cp];
            int[] width = new int[inPinCount];
            int[] edges = new int[inPinCount];
            int[] dutys = new int[inPinCount];

            cp = 0;
            for (int i = 0; i < inPinCount; i++)
            {
                if (!clockEnabled[i]) continue;
                sort[cp++] = i;
                b = boolStreams[i][l];
                width[i] = b.RepetitiveCount;
                edges[i] = b.Edge;
                dutys[i] = b.Duty;
            }

            for (int i = 0; i < cp; i++)
                for (int j = 0; j < cp - 1; j++)
                    if (width[sort[j]] > width[sort[j + 1]]) swap(ref sort, j);

            for (int i = 0; i < cp; i++)
                for (int j = 0; j < cp - 1; j++)
                    if ((width[sort[j]] == width[sort[j + 1]]) && (edges[sort[j]] < edges[sort[j + 1]])) swap(ref sort, j);

            int maxWidth = width[sort[cp - 1]];
            for (int i = cp - 1; i >= 0; i--)
            {
                if (width[sort[i]] < maxWidth) break;
                if (width[i] == 4) break;
                if ((edges[i] == 1) && (dutys[i] == 2))
                {
                    if (i < cp - 1) swap(ref sort, i, cp - 1);
                    cary[l] = true;
                    break;
                }
            }
            
            return sort;
        }
        private void swap(ref int[] sort, int j, int cp)
        {
            int temp = sort[j];
            for (int i = j; i < cp; i++)
                sort[i] = sort[i + 1];
            sort[cp] = temp;
        }
        private void swap(ref int[] sort, int j)
        {
            int temp = sort[j];
            sort[j] = sort[j + 1];
            sort[j + 1] = temp;
        }

        public override string ToString()
        {
            string s = "";
            for (int i = 0; i < diffCounter; i++)
            {
                if (i > 0) s += "\r\n\r\n";
                s += "Sequence" + i + ": ";
                string s2 = minSequences[i].ToString();
                if (s2 != "") s += s2; else s += "Clear";
                s += "\r\n    Bit order: " + minSequences[i].BitOrder();
                s2 = seqPIQueue[i].ToPinString();
                if (s2 != "") s += "\r\n    Logic:" + s2;
                else s += "\r\n    Always true.";
            }

            return s;
        }
    }

    class Sequence
    {
        bool cary;
        int[] seq;
        int[] sort;
        public int[] Sort { get { return sort; } }
        int inPinCount;
        int width;
        public int Width { get { return width; } }

        public Sequence(BoolStream[] boolStream, bool cary, int[] sort)
        {
            this.cary = cary;
            this.sort = sort;
            inPinCount = boolStream.Length;
            if (cary) inPinCount--;
            int maxWidth = 0;
            for (int i = 0; i < inPinCount; i++)
                if (maxWidth < boolStream[i].RepetitiveCount)
                    maxWidth = boolStream[i].RepetitiveCount;
            width = maxWidth;
            this.seq = new int[width];
            for (int j = 0; j < maxWidth; j++)
            {
                int t = 0;
                for (int i = 0; i < inPinCount; i++)
                {
                    if (boolStream[i].Rep[j % boolStream[i].RepetitiveCount]) t += 1 << i;
                }
                seq[j] = t;
            }

            //rotate();
            //halfSeq();
        }

        private void halfSeq()
        {
            width = width / 2;
            int[] halfseq = new int[width];
            for (int i = 0; i < width; i++)
                halfseq[i] = seq[i * 2];
            seq = halfseq;
        }

        private void rotate()
        {
            int temp = seq[seq.Length - 1];
            for (int i = seq.Length - 1; i > 0; i--)
                seq[i] = seq[i - 1];
            seq[0] = temp;
        }

        static public bool operator ==(Sequence a, Sequence b)
        {
            if (a.cary != b.cary) return false;
            if (a.width != b.width) return false;
            if (a.inPinCount != b.inPinCount) return false;
            for (int i = 0; i < a.inPinCount; i++)
                if (a.sort[i] != b.sort[i]) return false;
            for (int i = 0; i < a.width; i++)
                if (a.seq[i] != b.seq[i]) return false;
            return true;
        }

        static public bool operator !=(Sequence a, Sequence b)
        {
            if (a.cary != b.cary) return true;
            if (a.width != b.width) return true;
            if (a.inPinCount != b.inPinCount) return true;
            for (int i = 0; i < a.inPinCount; i++)
                if (a.sort[i] != b.sort[i]) return true;
            for (int i = 0; i < a.width; i++)
                if (a.seq[i] != b.seq[i]) return true;
            return true;
        }

        public override bool Equals(object obj)
        {
            return base.Equals(obj);
        }

        public override int GetHashCode()
        {
            return base.GetHashCode();
        }

        public string BitOrderOld()
        {
            string s = "[";
            int length = sort.Length - 1;
            for (int i = 0; i < length; i++)
                s += "Bit" + i + ": P" + Pin.outPinCode[sort[i]] + ", ";
            if (cary) s += "cary: P" + Pin.outPinCode[sort[length]] + "]";
            else s += "Bit" + length + ": P" + Pin.outPinCode[sort[length]] + "]";
            return s;
        }

        public string BitOrder()
        {
            string s = "[";
            int length = sort.Length - 1;
            for (int i = 0; i < length; i++)
                s += "P" + Pin.outPinCode[sort[i]] + ", ";
            if (cary) s += "cary: P" + Pin.outPinCode[sort[length]] + "]";
            else s += "P" + Pin.outPinCode[sort[length]] + "]";
            return s;
        }

        public override string ToString()
        {
            string s = "";
            for (int i = 0; i < width; i++)
            {
                if (i > 0) s += ".";
                s += seq[i];
            }
            return s;
        }
    }
}
